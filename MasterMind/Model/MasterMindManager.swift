//
//  MasterMindManager.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/6/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation
import UIKit

class MasterMindManager: randomAPIDelegate {
    
    let num = 4
    let min = 0
    let max = 7
    var randomIntAPI: RandomIntAPI?
    private var correctKey = [Int]()
    var guessKey = [Int]()
    var white = 0
    var black = 0
    
    init(){
        randomIntAPI = RandomIntAPI(num: num, min: min, max: max)
        randomIntAPI?.delegate = self
    }
    // randomAPIDelegate func didUpdateRandomAPI
    func didUpdateRandomAPI(stringData: String) {
        DispatchQueue.main.async {
            self.assignKeyToAnswerKey(stringData)
        }
    }
    // randomAPIDelegate func didFailWithError
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func assignKeyToAnswerKey(_ stringData: String) {
        correctKey.removeAll()
        let splitString = stringData.split(separator: "\n")
        splitString.forEach {
            if let number = Int($0) { correctKey.append(number) }
        }
    }
    // Return the Int that pair with color
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
        }
        return -1
    }
    // TODO Not calculate correct
    func calculateResult() {
        var total = 0
        var exact = 0
        var array = [Int]()
        for i in 0...7 {
            array.append(i)
        }
        var counts: [Int: Int] = [:]
        var index = 0
        for gN in guessKey {
            if gN == correctKey[index] {
                exact += 1
            }
            index += 1
            counts[gN] = (counts[gN] ?? 0) + 1
        }
        for cN in correctKey {
            total += counts[cN] ?? 0
            if counts[cN] != nil && counts[cN] != 0 {
                counts[cN]! -= 1
            }
            print("couts: \(counts)")
            print("total: \(total)")
            print("CN: \(cN)")
        }
        print("exact\(exact)")
        white = total - exact
        black = exact
    }
}
// Extension for comparing UIColor
extension UIColor {
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
