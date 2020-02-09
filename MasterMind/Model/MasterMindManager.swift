//
//  MasterMindManager.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/6/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation
import UIKit

class MasterMindManager {
    
    private var correctKey = [Int]()
    var guessKey = [Int]()
    var numberOfWhitePins = 0
    var numberOfBlackPins = 0
    var scoreCalculator = ScoreCalculate()
    let gameSoundController = GameSound()
    
    func assignKeyToCorrectKey(_ stringData: String) {
        correctKey.removeAll()
        let splitString = stringData.split(separator: "\n")
        splitString.forEach {
            if let number = Int($0) { correctKey.append(number) }
        }
    }
    
    func getNumberFromColor(_ color: UIColor) -> Int {
        // Return the Int that pair with each color
        if color == UIColor.black {
            return 0
        } else if color == UIColor.systemBlue {
            return 1
        } else if color == UIColor.systemPurple {
            return 2
        } else if color == UIColor.systemGreen {
            return 3
        } else if color == UIColor.systemOrange {
            return 4
        } else if color == UIColor.systemRed {
            return 5
        } else if color == UIColor.systemTeal {
            return 6
        } else if color == UIColor.systemIndigo {
            return 7
        }
        return -1
    }
    
    func calculateResult() {
        // calculate the result of the player guess
        var total = 0
        var exact = 0
        var counts: [Int: Int] = [:]
        guard correctKey.count != 0 || guessKey.count != 0
            else {
                return
        }
        for (eachGuessKey, eachCorrectKey) in zip(guessKey, correctKey) {
            if eachGuessKey == eachCorrectKey {
                exact += 1
            }
            counts[eachGuessKey] = (counts[eachGuessKey] ?? 0) + 1
        }
        correctKey.forEach {
            let index = $0
            if counts[index] != nil && counts[index]! > 0 {
                total += 1
                counts[index]! -= 1
            }
        }
        numberOfWhitePins = total - exact
        numberOfBlackPins = exact
    }
    
    func claculateFinalScore(numberOfTries: Int, gameTimeRemain: Int) {
        
        if numberOfBlackPins == 4 {
            scoreCalculator.calculateScore(numberOfTries, gameTimeRemain)
        }
    }
    
    func getFinalResult() -> GameResult {
        // return the fianl game result
        if numberOfBlackPins == 4 {
            let gameResult = GameResult(didWin: true, finalScore: scoreCalculator.getFinalScore())
            return gameResult
        } else {
            let gameResult = GameResult(didWin: false, finalScore: scoreCalculator.getFinalScore())
            return gameResult
        }
    }
}

extension UIColor {
    
    // MARK: - Extension for comparing UIColor
    
  static func == (l: UIColor, r: UIColor) -> Bool {
    var r1: CGFloat = 0
    var g1: CGFloat = 0
    var b1: CGFloat = 0
    var a1: CGFloat = 0
    l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    var r2: CGFloat = 0
    var g2: CGFloat = 0
    var b2: CGFloat = 0
    var a2: CGFloat = 0
    r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
  }
}
func == (l: UIColor?, r: UIColor?) -> Bool {
  let l = l ?? .clear
  let r = r ?? .clear
  return l == r
}
