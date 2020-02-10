//
//  BaseGameViewContrloller.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/9/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class BaseGameViewController: UIViewController {
    
    var tableOfButtons = [[UIButton]]()
    var currentSelectButton: UIButton?
    var lastReplaceButton: UIButton?
    var tableRowIndex = 0
    var tableOfPinsImageView = [[UIImageView]]()
    var currentRowPin = [UIImageView]()
    let masterMindManager = MasterMindManager()
    var resetGameDelegate: resetGameDelegate?
    var timer: Timer?
    var currentTime = 180
    var gameStat: GameStat?
    
    func startGame() {
        
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
    
    // MARK: - Buttons functions
    
    func enableButtons(_ currentRowButton: [UIButton]) {
        currentRowButton.forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    func disableButtons(_ currentRowButton: [UIButton]) {
        currentRowButton.forEach {
            $0.isUserInteractionEnabled = false
        }
    }
    
    func setButtonToSelectImage() {
        // Indicate which buttons is currently selected
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
    
    func moveToNextButton() {
        // After user select color, will automatic move to the next item
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
    
    func assignPinColor(_ currentRowPins: [UIImageView]) {
        // Replace the Pin image after get the number from the Manager
        var indexForNumPinColor = 0
        tableOfPinsImageView[tableRowIndex
        ].forEach {
            //TODO Number Not Correct
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
    
    func assignGuessKey(_ currentRowButton: [UIButton]) {
        // assigned the guesskey to the Manager
        masterMindManager.guessKey.removeAll()
        currentRowButton.forEach {
            if let color = $0.backgroundColor {
                let key = masterMindManager.getNumberFromColor(color)
                masterMindManager.guessKey.append(key)
            }
        }
    }
    
    // MARK: - reset table for both pins and buttons
    
    func resetTablePinsImage() {
        // resetPinsColor to original state
        tableOfPinsImageView.forEach {
            $0.forEach {
                $0.image = UIImage(systemName: "pin")
                $0.setImageColor(color: UIColor.black)
            }
        }
    }
    
    func resetTableButtons() {
        // reset all the buttons to original state
        tableOfButtons.forEach {
            $0.forEach {
                $0.backgroundColor = UIColor.white
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
    
    // MARK: - add beeting animation to currentButton
    
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

