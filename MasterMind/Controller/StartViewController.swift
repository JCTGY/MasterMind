//
//  StartViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

/**
## StartViewController

entry point of the game, can segue to RuleViewController, NormalGameViewController,
and HardGameViewController

- starting point of the game
- have extension `RandomAPIDelegate` to fetch correctKey

## Warnings

1. Make sure to call fetchRandomInt in the viewDidLoad so the data can properly pass to the game
2. Make sure to sign both randomAPIDelegate to self
*/
class StartViewController: UIViewController {
  let segueIdentifierNormal = GameStat.segueIdentifier.goToNormalMode.rawValue
  let segueIdentifierHard = GameStat.segueIdentifier.goToHardMode.rawValue
  let segueIdentifierRule = GameStat.segueIdentifier.goToRule.rawValue
  var randomIntAPINormalMode = RandomIntAPI(num: 4, min: 0, max: 7)
  var randomIntAPIHardMode = RandomIntAPI(num: 6, min: 0, max: 7)
  var correctKeyNormalMode: String?
  var correctKeyHardMode: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    /* Do any additional setup after loading the view. */
    randomIntAPINormalMode.delegate = self
    randomIntAPINormalMode.fetchRandomInt(isNormalMode: true)
    randomIntAPIHardMode.delegate = self
    randomIntAPIHardMode.fetchRandomInt(isNormalMode: false)
  }

  @IBAction func startNormalModeButton(_ sender: UIButton) {
    /* start button for Normal game mode */
    self.performSegue(withIdentifier: segueIdentifierNormal, sender: self)
  }

  @IBAction func startHardModeButton(_ sender: UIButton) {
    /* start button for Hard game mode */
    self.performSegue(withIdentifier: segueIdentifierHard, sender: self)
  }

  /**
   override func the send gameStat to the next viewController either Noram/Hard
   - warning: make sure to have the correct segue.identifier
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifierNormal {
      if let destinationVC = segue.destination as? NormalGameViewController {
        guard let correctKeyNormalMode = correctKeyNormalMode
          else {
            return
        }
        let gameStat = GameStat(correctKey: correctKeyNormalMode, isNormalMode: true)
        destinationVC.gameStat = gameStat
      }
    }
    if segue.identifier == segueIdentifierHard {
      guard let correctKeyHardMode = correctKeyHardMode
        else {
          return
      }
      if let destinationVC = segue.destination as? HardGameViewController {
        let gameStat = GameStat(correctKey: correctKeyHardMode, isNormalMode: false)
        destinationVC.gameStat = gameStat
      }
    }
  }

  @IBAction func ruleButton(_ sender: UIButton) {
    /* activate RuleViewController */
    self.performSegue(withIdentifier: segueIdentifierRule, sender: self)
  }

  /**
   dismissSackViews will dismiss everything on top of the current view
   while will reset the game back to StartViewController
   */
  func dismissStackViews() {
    dismiss(animated: true)
  }
}

extension StartViewController: RandomAPIDelegate {

  //MARK: delegate for randomIntAPI fetching data

  /**
   async fetching random API data
   - parameter stringData: data that did fetch from the random.org
   - parameter isNormalMode: indicate the current game mode
   */
  func didUpdateRandomAPI(stringData: String, _ isNormalMode: Bool) {
    DispatchQueue.main.async {
      if isNormalMode == true {
        self.correctKeyNormalMode = stringData
      } else {
        self.correctKeyHardMode = stringData
      }
      print(stringData)
    }
  }
  
  func didFailWithError(error: Error) {
    /* randomAPIDelegate func didFailWithError */
    print(error)
  }
}
