//
//  finalPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol resetGameDelegate {

  // MARK: - protocol for reseting game when player press continue button
  
  func didResetGame(newKey: String)
}

/**
## FinalPopUpViewController

- if player win, player can hit continue
- else player will end the game

- display the result to player
- have extension `resetGameDelegate` to reset the game
*/
class FinalPopUpViewController: UIViewController {
  @IBOutlet weak var finalDisplay: UILabel!
  @IBOutlet weak var popUpButton: UIButton!

  var gameStat: GameStat?
  var delegate: resetGameDelegate?

  /**
   get the `StartViewController`
   - returns: StartViewController that is unwrapped but optional
  */
  func getStatViewController() -> StartViewController? {
    if let startViewController = UIApplication.shared.windows
      .first?.rootViewController as? StartViewController {
      return startViewController
    }
    return nil
  }

  /**
   - set the new game correct key
   - check which mode to fetch new key
   */
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
    /* display the popUp text filed */
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

  /**
   - If the player win, the game will reset to last viewController with the current score but new game
   - if the player lose, the game will be back to the `StartViewController`
   */
  @IBAction func popUpButton(_ sender: UIButton) {
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
