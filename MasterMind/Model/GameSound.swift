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
    
    var audioBackgroundPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    var disableSound = false
    
    func playBackgroundSong() {
        guard let audioSourcePath = Bundle.main.path(forResource: "Background", ofType: "mp3")
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
    
    func soundForPlayerSelect() {
        
        if disableSound == true {
            return
        }
        guard let audioSourcePath = Bundle.main.path(forResource: "playerSelect", ofType: "wav")
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
    
    func soundForPlayerDeselect() {
        
        if disableSound == true {
            return
        }
        guard let audioSourcePath = Bundle.main.path(forResource: "playerDeselect", ofType: "wav")
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
    
    func soundForPlayerSubmit() {
        
        if disableSound == true {
            return
        }
        guard let audioSourcePath = Bundle.main.path(forResource: "submit", ofType: "wav")
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
