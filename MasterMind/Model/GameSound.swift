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
    
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundSong() {
        guard let audioSourcePath = Bundle.main.path(forResource: "Easy_Seas", ofType: "mp3")
            else {
                return
        }
        let audioSourceURL = URL(fileURLWithPath: audioSourcePath)
        do {
            print("play sound")
            audioPlayer = try AVAudioPlayer.init(contentsOf: audioSourceURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
}
