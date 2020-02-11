//
//  stopPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol PasuePopUpViewControllerDelegate {

  // MARK: - protocol for resumimg GameTimer and stop gameSound

  func resumeGameTimer()
  func stopGameSound(isSound: Bool)
}

/**
## PausePopUpViewController

player can pasue the game and change player setting

- player can turn off the music
- player can end the game
- player can pause and resume the game

*/
class PausePopUpViewController: UIViewController {
  var delegate: PasuePopUpViewControllerDelegate?
  var isSoundDisable: Bool?
  var isNormalMode: Bool?
  
  @IBOutlet weak var muteButtonLabel: UIButton!

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

  func displayMuteButton() {
    /* display the text field for mute button */
    guard isSoundDisable != nil
      else {
        return
    }
    if isSoundDisable == true {
      muteButtonLabel.setTitle("Unmute", for: .normal)
    } else {
      muteButtonLabel.setTitle("Mute", for: .normal)
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    displayMuteButton()
  }

  @IBAction func resumeButton(_ sender: UIButton) {
    /* resume the timer */
    self.delegate?.resumeGameTimer()
    dismiss(animated: true, completion: nil)
  }

  /**
   - call `randomIntAPINormalMode.fetchRandomInt` to get the new correctKey
   - dismissall the stack views, back to `startViewController`
   */
  @IBAction func endGameButton(_ sender: UIButton) {
    if let startViewController = getStatViewController() {
      if isNormalMode == true {
        startViewController.randomIntAPINormalMode.fetchRandomInt(isNormalMode: true)
      } else {
        startViewController.randomIntAPIHardMode.fetchRandomInt(isNormalMode: false)
      }
      startViewController.dismissStackViews()
    }
  }

  @IBAction func muteButton(_ sender: UIButton) {
    /* use delegate to call last ViewController to stop the sound*/
    if sender.titleLabel?.text == "Mute" {
      sender.setTitle("Unmute", for: .normal)
      delegate?.stopGameSound(isSound: true)
    } else {
      sender.setTitle("Mute", for: .normal)
      delegate?.stopGameSound(isSound: false)
    }
  }
}
