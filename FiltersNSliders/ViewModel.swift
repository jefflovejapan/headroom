//
//  ViewModel.swift
//  FiltersNSliders
//
//  Created by Jeffrey Blagdon on 2024-06-11.
//

import Foundation
import AVFoundation
import AudioKit

class ViewModel: ObservableObject {
    enum Error: Swift.Error {
        case noFile(String)
        case noAudioTracks
    }
    
    @MainActor
    @Published var trackInfo: String?
    @MainActor
    @Published var fftBins: [Float] = []
    private(set) var bufferSize: UInt32 = 512
    private var player: AudioPlayer?
    private let engine: AudioEngine
    private var tap: FFTTap?
    
    init() throws {
        self.engine = AudioEngine()
    }
        
    @MainActor
    func load(path: String, pathExtension: String) async throws {
        guard let url = Bundle.main.url(forResource: path, withExtension: pathExtension) else {
            let bundlePath = Bundle.main.bundlePath
            for item in (try? FileManager.default.contentsOfDirectory(atPath: bundlePath)) ?? [] {
                print("Found something: \(item)")
            }
            
            throw Error.noFile(path)
        }
        
        let audioFile: AVAudioFile = try AVAudioFile(forReading: url)
        let player = AudioPlayer(file: audioFile)!
        engine.output = player
        try self.engine.start()
        self.player = player
        
        let tap = FFTTap(player) { floats in
            self.fftBins = floats
        }
        self.tap = tap
        tap.start()
        player.play()
    }
}
