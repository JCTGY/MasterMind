//
//  GameSound.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation
import AVFoundation

class GameSound {
    
    let backgroundFileName = "Background"
    let selectFileName = "playerSelect"
    let submitFileName = "submit"
    var audioBackgroundPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    var disableSound = false
    
    func diableSoundPlayer() {
        
        disableSound = true
        guard audioBackgroundPlayer != nil
            else {
                return
        }
        audioBackgroundPlayer?.stop()
    }
    
    func enableSoundPlayer() {
        
        disableSound = false
        playBackgroundSong()
    }
    
    func playBackgroundSong() {
        let fileType = "mp3"
        guard let audioSourcePath = Bundle.main.path(forResource: backgroundFileName, ofType: fileType)
            else {
                return
        }
        do {
            audioBackgroundPlayer = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath: audioSourcePath))
            audioBackgroundPlayer?.volume = 0.3
            audioBackgroundPlayer?.prepareToPlay()
            audioBackgroundPlayer?.play()
            audioBackgroundPlayer?.numberOfLoops = -1
        } catch {
            print(error)
        }
    }
    
    func playSoundEffect(_ fileNameOfSoundEffct: String) {
        
        let fileType = "wav"
        if disableSound == true {
            return
        }
        guard let audioSourcePath = Bundle.main.path(forResource: fileNameOfSoundEffct, ofType: fileType)
            else {
                return
        }
        do {
            soundEffectPlayer = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath: audioSourcePath))
            soundEffectPlayer?.volume = 1.0
            soundEffectPlayer?.prepareToPlay()
            soundEffectPlayer?.play()
        } catch {
            print(error)
        }
    }
}
