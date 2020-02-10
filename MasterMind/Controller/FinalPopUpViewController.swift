//
//  finalPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol resetGameDelegate {
    // MARK: - protocol for receting game while press continue button
    
    func didResetGame(newKey: String)
}

class FinalPopUpViewController: UIViewController {
    
    @IBOutlet weak var finalDisplay: UILabel!
    @IBOutlet weak var popUpButton: UIButton!
    
    var gameStat: GameStat?
    var delegate: resetGameDelegate?
    
    func getStatViewController() -> StartViewController? {
        
        if let startViewController = UIApplication.shared.windows
            .first?.rootViewController as? StartViewController {
            return startViewController
        }
        return nil
    }
    
    func setNextGameCorrectKey() {
        if let startViewController = getStatViewController() {
            if gameStat?.isNormalMode == true {
                startViewController.randomIntAPINormalMode
                    .fetchRandomInt(isNormalMode: true)
            } else {
                startViewController.randomIntAPIHardMode
                    .fetchRandomInt(isNormalMode: false)
            }
        }
    }
    
    func setPopUpMenuTitle() {
        
        guard let finalScore = gameStat?.finalScore
            else {
                return
        }
        if gameStat?.didWin == true {
            print("You Win!\nScore: \(finalScore)")
            finalDisplay.text = "You Win!\nScore: \(finalScore)"
            popUpButton.setTitle("Continue", for: .normal)
        } else {
            finalDisplay.text = "You Lose!\nScore: \(finalScore)"
            popUpButton.setTitle("End Game", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNextGameCorrectKey()
        setPopUpMenuTitle()
    }
    
    @IBAction func popUpButton(_ sender: UIButton) {
        // Set to the rootViewController
        if let startViewController = getStatViewController() {
            if gameStat?.didWin == true {
                var tmpCorrectKey: String?
                if gameStat?.isNormalMode == true {
                    tmpCorrectKey = startViewController.correctKeyNormalMode
                } else {
                    tmpCorrectKey = startViewController.correctKeyHardMode
                }
                guard let correctKey = tmpCorrectKey
                    else {
                        return
                }
                self.delegate?.didResetGame(newKey: correctKey)
            } else {
                startViewController.dismissStackViews()
            }
        }
    }
}
