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

    func calculateScore(_ numberOfTries: Int, _ gameTimeRemain: Int) {

        finalScore += 100 - (numberOfTries * 9) + (gameTimeRemain / 5)
    }

    func getFinalScore() -> String {

        return String(finalScore)
    }
}
