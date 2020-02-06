//
//  MasterMindManager.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/6/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

class MasterMindManager: randomAPIDelegate {
    
    var randomIntAPI = RandomIntAPI(num: 4, min: 0, max: 7)
    init(){
        randomIntAPI.delegate = self
    }
    func didUpdateRandomAPI(stringData: String) {
        print(stringData)
    }
}
