//
//  GameStat.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/9/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

/**
## GameStat

GameStat save the game stat

- correctKey: save the key player have to guess
- isNormalMode: define is the game current in Normal or hard mode
- didWin: indicate did the player win or not
- finalScore: save the finalScore of th player get

*/
struct GameStat {
  let userName: String
  let correctKey: String
  let isNormalMode: Bool
  let numOfRows: Int
  let numOfKeys: Int
  var didWin = false
  var finalScore = 0
}
