//
//  SoundManager.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import AVFoundation

final class SoundManager: SoundManagerProtocol {
    private var player: AVAudioPlayer?

    func playSound(named fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            debugPrint("Sound file not found: \(fileName)")
            return
        }

        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            debugPrint("Error playing sound: \(error.localizedDescription)")
        }
    }
}

protocol SoundManagerProtocol {
    func playSound(named fileName: String)
}
