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
    private(set) var bufferSize: UInt32 = 512
    private let engine: AVAudioEngine
    private let playerNode: AVAudioPlayerNode
    private var audioFile: AVAudioFile?
    private var player: AudioPlayer?
    
    init() {
        let playerNode = AVAudioPlayerNode()
        let engine = AVAudioEngine()
        engine.attach(playerNode)
        self.engine = engine
        self.playerNode = playerNode
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
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
        
        let engine = AudioEngine()
        
        let audioFile: AVAudioFile = try AVAudioFile(forReading: url)
        let player = AudioPlayer(file: audioFile)!
        engine.output = player
        try engine.start()
        self.player = player
        player.play()
        
        
        
//        let audioSession = AVAudioSession.sharedInstance()
//        try audioSession.setCategory(.playback, mode: .default, options: [])
//        try audioSession.setActive(true)
//        
//        self.audioFile = audioFile
        
//        engine.outputNode.installTap(onBus: 0, bufferSize: 1024, format: audioFile.processingFormat) { buffer, time in
//            print("Got a buffer: \(buffer) at time: \(time)")
//        }

        try engine.start()
        await playerNode.scheduleFile(audioFile, at: nil)
        playerNode.play()
        
        print("Player node started")

    }
}
