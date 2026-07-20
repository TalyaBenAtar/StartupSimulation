//
//  SoundManager.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 20/07/2026.
//

import Foundation
import AVFoundation

final class SoundManager {

    static let shared = SoundManager()

    private var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?

    private init() {}

    // MARK: - Background Music

    func playBackgroundMusic() {
        playMusic(named: "background_music")
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }

    // MARK: - Sound Effects

    func playUnicorn() {
        playEffect(named: "unicorn")
    }

    func playBankruptcy() {
        playEffect(named: "bankruptcy")
    }

    func playSold() {
        playEffect(named: "sold")
    }

    // MARK: - Private

    private func playMusic(named file: String) {

        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3") else {
            print("Missing music: \(file)")
            return
        }

        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.volume = 0.25
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.play()
        } catch {
            print(error)
        }
    }

    private func playEffect(named file: String) {

        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3") else {
            print("Missing sound: \(file)")
            return
        }

        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer?.volume = 1.0
            effectPlayer?.prepareToPlay()
            effectPlayer?.play()
        } catch {
            print(error)
        }
    }
}
