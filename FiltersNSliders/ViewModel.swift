//
//  ViewModel.swift
//  FiltersNSliders
//
//  Created by Jeffrey Blagdon on 2024-06-11.
//

import Foundation
import AVFoundation

class ViewModel: ObservableObject {
    enum Error: Swift.Error {
        case noFile(String)
        case noAudioTracks
    }
    
    @MainActor
    @Published var trackInfo: String?
        
    @MainActor
    func load(path: String, pathExtension: String) async throws {
        guard let url = Bundle.main.url(forResource: path, withExtension: pathExtension) else {
            let bundlePath = Bundle.main.bundlePath
            for item in (try? FileManager.default.contentsOfDirectory(atPath: bundlePath)) ?? [] {
                print("Found something: \(item)")
            }
            
            throw Error.noFile(path)
        }
        let avAsset = AVAsset(url: url)
            
        guard let audioTrack = try await avAsset.loadTracks(withMediaType: .audio).first else {
            throw Error.noAudioTracks
        }
        self.trackInfo = "\(try await audioTrack.load(.timeRange).duration.seconds) seconds of audio"
    }
}
