//
//  ScoreCalulate.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

class ScoreCalculate {
  private(set) var finalScore = 0

  /**
    calculate the score base on remaining time and number of tries
    - parameter numberOfTries: how many times have the player tries
    - parameter gameTimeRemain: how much time remaining
    - returns: Void
    */
  func calculateScore(_ numberOfTries: Int, _ gameTimeRemain: Int) {
    finalScore += 100 - (numberOfTries * 7) + (gameTimeRemain / 5)
  }

  /**
   getter for FinalScore
   - returns: return finalScore
   */
  func getFinalScore() -> Int {
    return finalScore
  }
}
