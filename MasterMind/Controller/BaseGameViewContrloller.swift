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

