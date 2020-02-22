//
//  BaseGameViewContrloller.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/9/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

/**
## BaseGameViewController

super class for `NormalGameViewController` and `HardGameViewController`

- starGame
- moving the selected buttons
- disable and enable row of buttons

## Warnings

use BaseGameViewController as an Interface
BaseGameViewController cannot be function without buttons and pins
*/
class BaseGameViewController: UIViewController {
  var tableOfButtons = [[UIButton]]()
  var currentSelectButton: UIButton?
  var lastReplaceButton: UIButton?
  var tableOfPinsImageView = [[UIImageView]]()
  var currentRowPin = [UIImageView]()
  var tableRowIndex = 0
  var currentTime = 180
  var timer: Timer?
  var resetGameDelegate: resetGameDelegate?
  var gameStat: GameStat?
  let masterMindManager = MasterMindManager()

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  override func viewDidLoad() {
    checkIsAppBackground()
    checkIsAppForground()
    intitailGameTimer()
    startGameTimer()
  }

    // MARK: - IBAction functions for buttons

    @IBAction func pauseGameTimerButton(_ sender: UIButton) {
      /* pause the GameTimer */
      timer?.invalidate()
    }

    /**
     click to remove colorof the button, and the button will be the current select button
     add sound effect from `masterMindManager.gameSoundController`
     */
    @IBAction func deselectColorButtons(_ sender: UIButton) {
      if lastReplaceButton != nil {
        lastReplaceButton?.setTitle("", for: .normal)
        lastReplaceButton?.layer.removeAllAnimations()
      }
      masterMindManager.gameSoundController.playSoundEffect(K.SoundFileName.select)
      currentSelectButton = sender
      setButtonToSelectImage()
      lastReplaceButton = sender
    }

    /**
     click one of the circle color buttons and will put that color to the current selected square button
     Also, remove animation from the last select button
     */
    @IBAction func colorSelectButtons(_ sender: UIButton) {
      guard let currentSelectButton = currentSelectButton,
        lastReplaceButton != nil
        else {
          return
      }
      masterMindManager.gameSoundController.playSoundEffect(K.SoundFileName.select)
      currentSelectButton.backgroundColor = sender.imageView?.tintColor
      moveToNextButton()
    }

    /**
     `assignGuessKey` to assigned `guessKey`
     `masterMindManager.calculateResult` to calculate the result
     `assignPinColor` to assgned the Pin for the player to see
     `disableRowOfButtons` then disable the current row of buttons
     check if the game is finish: player use all the tires, then will call `gameFinish()` method
     else will move to the next row of buttons
     */
    @IBAction func submitButton(_ sender: UIButton) {
      // Check if every bottons is selected with a color
      guard tableOfButtons.count > tableRowIndex
        || tableOfPinsImageView.count > tableRowIndex
        else {
          return
      }
      for button in tableOfButtons[tableRowIndex] {
        guard button.backgroundColor != UIColor.white else {
          return ;
        }
      }
      currentSelectButton?.layer.removeAllAnimations()
      masterMindManager.gameSoundController.playSoundEffect(K.SoundFileName.submit)
      assignGuessKey(tableOfButtons[tableRowIndex])
      masterMindManager.calculateResult()
      assignPinColor(tableOfPinsImageView[tableRowIndex])
      disableRowOfButtons(tableOfButtons[tableRowIndex])
      moveToNextRowOfButtons()
    }

    /**
     check if the game is finish: player use all the tires, then will call `gameFinish()` method
     else will move to the next row of buttons
     */
    func moveToNextRowOfButtons() {

      // MARK: - Increment the `tableRowIndex`

      tableRowIndex += 1
      if tableOfButtons.count <= tableRowIndex
        || masterMindManager.numberOfBlackPins == tableOfPinsImageView.first?.count {
        gameFinish()
        return
      }
      enableRowOfButtons(tableOfButtons[tableRowIndex])
      lastReplaceButton?.setTitle("", for: .normal)
      currentSelectButton = tableOfButtons[tableRowIndex].first
      lastReplaceButton = currentSelectButton
      setButtonToSelectImage()
    }

    /**
     - move game stat to the `FinialPopUpViewController`
     - or move current sound and game mode to `PauselPopUpViewController`
     - warning: Make sure have the correct `segue.identifier`
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // send result to `FinalPopUpViewController`
      if segue.identifier == K.endPopUpSegue {
        if let destinationVC = segue.destination as? FinalPopUpViewController {
          destinationVC.delegate = self
          guard let firstPinsRow = tableOfPinsImageView.first,
            let gameStat = gameStat
            else {
              return
          }
          destinationVC.gameStat = masterMindManager.getFinalResult(firstPinsRow.count, gameStat)
          destinationVC.isModalInPresentation = true
        }
      } else if segue.identifier == K.pausePopUpSegue {
        if let destinationVC = segue.destination as? PausePopUpViewController {
          destinationVC.delegate = self
          destinationVC.isSoundDisable = masterMindManager.gameSoundController.disableSound
          destinationVC.isNormalMode = gameStat?.isNormalMode
          destinationVC.isModalInPresentation = true
        }
      } else {
        assertionFailure("Segue identifier inValid")
      }
    }

  func startGame() {
    /* initiate the game, check if correctKey and buttons exsist */
    guard let correctKeyString = gameStat?.correctKey,
      let firstRowButton = tableOfButtons.first
      else {
        return
    }
    currentSelectButton = firstRowButton.first
    lastReplaceButton = firstRowButton.first
    setButtonToSelectImage()
    masterMindManager.assignKeyToCorrectKey(correctKeyString)
    masterMindManager.gameSoundController.playBackgroundSong()
  }

  // MARK: - Check if app is on background/forground

  func checkIsAppBackground() {
    /* check if the app move to the background call `appMovedToBackground` */
    let notificationCenter = NotificationCenter.default
     notificationCenter.addObserver(self, selector: #selector(appMovedToBackground),
                                    name: UIApplication.didEnterBackgroundNotification, object: nil)
  }

  @objc func appMovedToBackground() {
    /* disable sound if app move to the background */
    masterMindManager.gameSoundController.diableSoundPlayer()
  }

  func checkIsAppForground() {
    /* check if app is going back to the forground */
    let notificationCenter = NotificationCenter.default
     notificationCenter.addObserver(self, selector: #selector(appMovedToForground),
                                    name: UIApplication.willEnterForegroundNotification, object: nil)
  }

  @objc func appMovedToForground() {
    /* enable sound if app back to the forground */
    masterMindManager.gameSoundController.enableSoundPlayer()
  }
  // MARK: - Buttons functions

  /**
   enable entire row of buttons
   - parameter currentRowButton: bottons want to be enable
   */
  func enableRowOfButtons(_ currentRowButton: [UIButton]) {
    currentRowButton.forEach {
      $0.isUserInteractionEnabled = true
    }
  }

  // MARK: - GameTimer funtions

  func intitailGameTimer () {
    /* intitailGameTimer and call `startGameTimer` */
    timer = Timer.scheduledTimer(timeInterval: 1.0,
                                 target: self, selector: #selector(startGameTimer),
                                 userInfo: nil, repeats: true)
  }

  func resetGameTimer() {
    /* reset game timer to back to 180 */
    timer?.invalidate()
    currentTime = 181
    intitailGameTimer()
    startGameTimer()
  }

  @objc func startGameTimer() {
    /* method theat display the timer, and perform the count down */
    currentTime -= 1

    if currentTime <= 0 {
      gameFinish()
    }
    timerLabel.text = "Timer: \(currentTime)"
  }


  /**
   disable entire row of buttons
   - parameter currentRowButton: bottons want to be disable
   */
  func disableRowOfButtons(_ currentRowButton: [UIButton]) {
    currentRowButton.forEach {
      $0.isUserInteractionEnabled = false
    }
  }

  /**
  give animation to Indicate which buttons is currently selected
  - warning: make sure `currentSelectButton` or it will not do anything
  */
  func setButtonToSelectImage() {
    guard let currentSelectButton = currentSelectButton
      else {
        return
    }
    currentSelectButton.showsTouchWhenHighlighted = true
    currentSelectButton.setTitle("O", for: .normal)
    currentSelectButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
    currentSelectButton.backgroundColor = UIColor.white
    currentSelectButton.pulseAnimation()
  }

  /**
  UI friendly feature that automatic move to the next button, so the player dont have to click
  Also, assigned the animation and color of the button while move to the new one
  - warning: make sure `tableRowIndex` is still within the range or it will not do anything
  */
  func moveToNextButton() {
    guard tableOfButtons.count > tableRowIndex
      else {
        return
    }
    let currentRowButtons = tableOfButtons[tableRowIndex]
    for button in currentRowButtons {
      if button.backgroundColor == UIColor.white {
        if lastReplaceButton != nil {
          lastReplaceButton?.setTitle("", for: .normal)
          lastReplaceButton?.layer.removeAllAnimations()
        }
        currentSelectButton = button
        setButtonToSelectImage()
        lastReplaceButton = button
        break
      }
    }
  }
  
  // MARK: - pinImageViews functions

  /**
  use `getNumberFromColor` from `MasterMindManager` to get
  the correct indicate number for each color. And store it as guessKey [Int]
  - parameter currentRowButton: current row of bottons player just submit
  */
  func assignGuessKey(_ currentRowButton: [UIButton]) {
    masterMindManager.guessKey.removeAll()
    currentRowButton.forEach {
      if let color = $0.backgroundColor {
        let key = masterMindManager.getNumberFromColor(color)
        masterMindManager.guessKey.append(key)
      }
    }
  }

  /**
   after `MasterMindManager` calculate the result
   assigned the result to each pin Images
   - parameter currentRowPins: current row of pins need to be fill
   - warning: make sure to have extension `setImageColor` in `UIImageView`
   to set the pin.fill color
  */
  func assignPinColor(_ currentRowPins: [UIImageView]) {
    // Replace the Pin image after get the number from the Manager
    var indexForNumPinColor = 0
    tableOfPinsImageView[tableRowIndex
    ].forEach {
      if indexForNumPinColor < masterMindManager.numberOfBlackPins {
        $0.image = UIImage(systemName: "pin.fill")
        $0.setImageColor(color: UIColor.black)
      } else if indexForNumPinColor < masterMindManager.numberOfBlackPins + masterMindManager.numberOfWhitePins{
        $0.image = UIImage(systemName: "pin.fill")
        $0.setImageColor(color: UIColor.white)
      }
      indexForNumPinColor += 1
    }
  }
  
  // MARK: - reset table for both pins and buttons

  func resetTableButtons() {
    /* reset entire table of buttons to the start state */
    tableOfButtons.forEach {
      $0.forEach {
        $0.backgroundColor = UIColor.white
      }
    }
  }

  func resetTablePinsImage() {
    /* reset entire table of pins to the start state */
    tableOfPinsImageView.forEach {
      $0.forEach {
        $0.image = UIImage(systemName: "pin")
        $0.setImageColor(color: UIColor.black)
      }
    }
  }

  /**
   - finish the current set of game
   - stop the timer and use timer and number of player tries to calculate result
   - `performSegue` to `move to the FinialPopUpViewController`
   */
  func gameFinish() {
    guard let firstRowPins = tableOfPinsImageView.first
      else {
        return
    }
    timer?.invalidate()
    masterMindManager.claculateFinalScore(tableRowIndex,
                                          currentTime, firstRowPins.count)
    let finalScore = masterMindManager.scoreCalculator.getFinalScore()
    scoreLabel.text = "Score: \(finalScore)"
    self.performSegue(withIdentifier: K.endPopUpSegue, sender: self)
  }

}

extension UIImageView {
  
  // MARK: - Set extension for change UIImageView color
  
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIButton {
  
  // MARK: - add animation beeting to currentButton
  
  func pulseAnimation() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.6
    pulse.fromValue = 0.95
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = 200
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    
    layer.add(pulse, forKey: "pulse")
  }
}


extension BaseGameViewController: resetGameDelegate {

  // MARK: - protocol call for reset `GameViewController`

  /**
   reset the entire game from reset the table of pins and buttons
   - parameter newKey: the new correctKey
   - warning: make sure assigned the delegate to the `FinalPopUpViewController`
  */
  func didResetGame(newKey: String) {
    tableRowIndex = 0
    masterMindManager.numberOfBlackPins = 0
    masterMindManager.numberOfWhitePins = 0
    resetGameTimer()
    guard let firstRowButton = tableOfButtons.first
      else {
        return
    }
    enableRowOfButtons(firstRowButton)
    currentSelectButton?.setTitle("", for: .normal)
    currentSelectButton = firstRowButton.first
    lastReplaceButton = firstRowButton.first
    resetTableButtons()
    resetTablePinsImage()
    setButtonToSelectImage()
    masterMindManager.assignKeyToCorrectKey(newKey)
    dismiss(animated: true, completion: nil)
  }
}

extension BaseGameViewController: PasuePopUpViewControllerDelegate {

  // MARK: - protocol call for `PasuePopUpViewControllerDelegate`

  func resumeGameTimer() {
    /* resume the current Timer */
    intitailGameTimer()
    startGameTimer()
  }

  func stopGameSound(isSound: Bool) {
    /* disable or enable the sound */
    if isSound == true {
      masterMindManager.gameSoundController.diableSoundPlayer()
    } else {
      masterMindManager.gameSoundController.enableSoundPlayer()
    }
  }
}

