//
//  LocalRandomInt.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/20/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

struct LocalRandomInt {

//  let localKey: [Int]

  func generateLocalKey(num: Int) -> String{

    var localKey =  [Int]()
    for _ in 1...num {
      localKey.append(Int.random(in: 0..<7))
    }
    let stringArray = localKey.map({String($0)})
    let localKeyString = stringArray.joined(separator: "\n")
    return localKeyString
  }
}
