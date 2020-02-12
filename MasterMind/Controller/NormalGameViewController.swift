//
//  ViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/5/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

/**
## NormalGameViewController

Connect modle and Noemal Game view together:

- inheritance from `BaseGameViewContrloller`
- Contain all the IBAction for buttons and the IBOutlet for pin images
- Control the GameTimer
- Main class controll all the display on Normal Mode

## Warnings

Make sure to assign all the buttons and pins
*/
class NormalGameViewController: BaseGameViewController {

  @IBOutlet var rowOne: [UIButton]?
  @IBOutlet var rowTwo: [UIButton]?
  @IBOutlet var rowThree : [UIButton]?
  @IBOutlet var rowFour : [UIButton]?
  @IBOutlet var rowFive : [UIButton]?
  @IBOutlet var rowSix : [UIButton]?
  @IBOutlet var rowSeven : [UIButton]?
  @IBOutlet var rowEight : [UIButton]?
  @IBOutlet var rowNine : [UIButton]?
  @IBOutlet var rowTen : [UIButton]?

  @IBOutlet var pinRowOne: [UIImageView]?
  @IBOutlet var pinRowTwo: [UIImageView]?
  @IBOutlet var pinRowThree: [UIImageView]?
  @IBOutlet var pinRowFour: [UIImageView]?
  @IBOutlet var pinRowFive: [UIImageView]?
  @IBOutlet var pinRowSix: [UIImageView]?
  @IBOutlet var pinRowSeven: [UIImageView]?
  @IBOutlet var pinRowEight: [UIImageView]?
  @IBOutlet var pinRowNine: [UIImageView]?
  @IBOutlet var pinRowTen: [UIImageView]?


  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!

  func appendtableOfButtons() {
    /* Append all the IBoutlet Buttons */
    tableOfButtons.append(rowOne!)
    tableOfButtons.append(rowTwo!)
    tableOfButtons.append(rowThree!)
    tableOfButtons.append(rowFour!)
    tableOfButtons.append(rowFive!)
    tableOfButtons.append(rowSix!)
    tableOfButtons.append(rowSeven!)
    tableOfButtons.append(rowEight!)
    tableOfButtons.append(rowNine!)
    tableOfButtons.append(rowTen!)
  }

  func appendtableOfPinsImageView() {
    /* Append all the IBoutlet PinsImageView */
    tableOfPinsImageView.append(pinRowOne!)
    tableOfPinsImageView.append(pinRowTwo!)
    tableOfPinsImageView.append(pinRowThree!)
    tableOfPinsImageView.append(pinRowFour!)
    tableOfPinsImageView.append(pinRowFive!)
    tableOfPinsImageView.append(pinRowSix!)
    tableOfPinsImageView.append(pinRowSeven!)
    tableOfPinsImageView.append(pinRowEight!)
    tableOfPinsImageView.append(pinRowNine!)
    tableOfPinsImageView.append(pinRowTen!)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    checkIsAppBackground()
    checkIsAppForground()
    appendtableOfButtons()
    appendtableOfPinsImageView()
    intitailGameTimer()
    startGameTimer()
    startGame()
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
      || masterMindManager.numberOfBlackPins == pinRowOne?.count {
      gameFinish()
      return
    }
    enableRowOfButtons(tableOfButtons[tableRowIndex])
    lastReplaceButton?.setTitle("", for: .normal)
    currentSelectButton = tableOfButtons[tableRowIndex].first
    lastReplaceButton = currentSelectButton
    setButtonToSelectImage()
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
}

extension NormalGameViewController: resetGameDelegate {

  // MARK: - protocol call for reset `GameViewController`

  /**
   reset the entire game from reset the table of pins and buttons
   - parameter newKey: the new correctKey
   - warning: make sure assigned the delegate to the `FinalPopUpViewController`
  */
  func didResetGame(newKey: String) {
    tableRowIndex = 0
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

extension NormalGameViewController: PasuePopUpViewControllerDelegate {

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
