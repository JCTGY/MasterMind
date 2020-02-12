//
//  GameSound.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation
import AVFoundation

/**
## GameSound

manage the sound of the game

- play background sound and sound effect
- can enable and disable the song

## Example

    let GameSound = GameSound()
    GameSound.playBackgroundSong()

- Warnings: Make sure to assign the fileName while calling `playSoundeffect`
*/
class GameSound {
  var audioBackgroundPlayer: AVAudioPlayer?
  var soundEffectPlayer: AVAudioPlayer?
  var disableSound = false

  /**
   diable sound player by switching Bool `disableSound` to true
   also stop the background audioPlayer
   */
  func diableSoundPlayer() {
    disableSound = true
    guard audioBackgroundPlayer != nil
      else {
        return
    }
    audioBackgroundPlayer?.stop()
  }

  /**
   diable sound player by switching Bool `disableSound` to false
   also start the background audioPlayer
   */
  func enableSoundPlayer() {
    disableSound = false
    playBackgroundSong()
  }

  /**
   start playing the backgroud music by using `AVAudioPlayer`
   - warning: make sure to define the correct fileName
   */
  func playBackgroundSong() {
    let fileType = "mp3"
    guard let audioSourcePath = Bundle.main.path(forResource: K.SoundFileName.background, ofType: fileType)
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

  /**
   start playing the backgroud music by using `AVAudioPlayer`
   - parameter fileNameOfSoundEffct: pass  in the filename of the sound effect to be played
   - warning: make sure to define the correct fileName
   */
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
