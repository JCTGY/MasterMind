//
//  GameStat.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/9/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

struct GameStat {
    
    let correctKey: String
    let isNormalMode: Bool
    var didWin = false
    var finalScore = 0
    
    enum segueIdentifier: String {
        case goToStopPopUp
        case goToEndPopUp
        case goToNormalMode
        case goToHardMode
        case goToRule
    }
}
