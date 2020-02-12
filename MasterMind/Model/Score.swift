//
//  Score.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/11/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

/**
## Score

struct for fetching and sending data to the firestore

- name: user name that user input in the textfield
- score: the score the ready to save to the firebase

*/
struct Score {
  let name: String
  let score: Int
}
