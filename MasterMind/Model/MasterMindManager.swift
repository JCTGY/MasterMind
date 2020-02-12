//
//  MasterMindManager.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/6/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation
import UIKit

/**
## MasterMindManager

Control, save and, calculate the  game stats:

- Turn randomAPI data into int array and store in the correct key
- Calculate and manage the final game result
- have gameSoundController to control the sound
- return the number that match to each color

## Example

    let masterMindManager = MasterMindManager()
    masterMindManager.calculateResult()

## Warnings

1. Make sure to assign correctKey and guessKey
2. `getNumberFromColor` only contain 7 differnt color
*/
class MasterMindManager {
  var correctKey = [Int]()
  var guessKey = [Int]()
  var numberOfWhitePins = 0
  var numberOfBlackPins = 0
  var scoreCalculator = ScoreCalculate()
  let gameSoundController = GameSound()

  /**
   turn colum of string interger into Int array

   - parameter stringData: plain text data from random.org
   - returns: Void
   */
  func assignKeyToCorrectKey(_ stringData: String) {
    correctKey.removeAll()
    let splitString = stringData.split(separator: "\n")
    splitString.forEach {
      if let number = Int($0) { correctKey.append(number) }
    }
  }
  
  func calculateResult() {
    /* calculate the result from comparing guessKey to correctKey */
    var total = 0
    var exact = 0
    var counts: [Int: Int] = [:]
    guard correctKey.count != 0 || guessKey.count != 0
      else {
        print("key did not assigned\n")
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

  /**
   calculate the final score when player win the game

   - parameter numberOfTries: how many times have the player tries
   - parameter gameTimeRemain: how much time remaining
   - parameter numberOfPins: number of pins, to make sure the player win
   - returns: Void
   */
  func claculateFinalScore(_ numberOfTries: Int, _ gameTimeRemain: Int, _ numberOfPins: Int) {
    if numberOfBlackPins == numberOfPins {
      scoreCalculator.calculateScore(numberOfTries, gameTimeRemain)
    }
  }

  /**
   calculate the final score when player win the game

   - parameter numberofPins: number of pins, to make sure the player win
   - parameter currentGameStat: add the previous gameStat to the new one
   - returns: return the final game result
   */
  func getFinalResult(_ numberofPins: Int, _ currentGameStat: GameStat) -> GameStat {
    var gameStat = currentGameStat
    if numberOfBlackPins == numberofPins {
      gameStat.didWin = true
      gameStat.finalScore = scoreCalculator.getFinalScore()
      return gameStat
    } else {
      gameStat.didWin = false
      gameStat.finalScore = scoreCalculator.getFinalScore()
      return gameStat
    }
  }

  /**
   calculate the final score when player win the game

   - parameter color: take in a UIColor to compare
   - returns: the represent number of the color
   */
  func getNumberFromColor(_ color: UIColor) -> Int {
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
}

/**
 extension operator for the UIColor, so UIcolor can correctly compare each other
 where UIColor.white == UIColor will return true
 */
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
