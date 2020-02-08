//
//  finalPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol resetGameDelegate {
    
    func didResetGame(newKey: String)
}

class FinalPopUpViewController: UIViewController {

    @IBOutlet weak var finalDisplay: UILabel!
    @IBOutlet weak var popUpButton: UIButton!
    
    var gameResult: GameResult?
    var delegate: resetGameDelegate?
    let viewController = UIApplication.shared.windows.first!.rootViewController as! StartViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewController.randomIntAPI.fetchRandomInt()
        guard let finalScore = gameResult?.finalScore
            else {
                return
        }
        if gameResult?.didWin == true {
            print("You Win!\nScore: \(finalScore)")
            finalDisplay.text = "You Win!\nScore: \(finalScore)"
            popUpButton.setTitle("Continue", for: .normal)
        } else {
            finalDisplay.text = "You Lose!\nScore: \(finalScore)"
            popUpButton.setTitle("End Game", for: .normal)
        }
    }
    
    @IBAction func popUpButton(_ sender: UIButton) {
        // Set to the rootViewController
        if gameResult?.didWin == true {
            guard let correctKeyString = viewController.correctKeyString
                else {
                    return
            }
            self.delegate?.didResetGame(newKey: correctKeyString)
        } else {
            viewController.dismissStackViews()
        }
    }
    

}
