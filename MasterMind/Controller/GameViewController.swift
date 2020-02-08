//
//  ViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/5/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    /* =========================== */
    /*       IBoutlet Buttons      */
    /* =========================== */
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
    var tableOfButtons = [[UIButton]]()
    var currentRowButtons: [UIButton]?
    var globalIndex = 0
    var currentSelectButton: UIButton?
    var lastReplaceButton: UIButton?
    
    /* =========================== */
    /*       IBoutlet pinView      */
    /* =========================== */
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
    var tableOfPinsImageView = [[UIImageView]]()
    var currentRowPin = [UIImageView]()
    
    let masterMindManager = MasterMindManager()
    var correctKeyString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendOutLetButtons()
        appendPinImageViews()
        guard let correctKeyString = correctKeyString
            else {
                return
        }
        masterMindManager.assignKeyToCorrectKey(correctKeyString)
    }
    //MARK: Buttons func
    @IBAction func actionForButtons(_ sender: UIButton) {
        if lastReplaceButton != nil {
            lastReplaceButton?.setTitle("", for: .normal)
        }
        currentSelectButton = sender
        setButtonToSelectImage()
        lastReplaceButton = sender
    }
    
    @IBAction func colorSelectButtons(_ sender: UIButton) {
        guard let currentSelectButton = currentSelectButton
            else {
                return
        }
        currentSelectButton.backgroundColor = sender.imageView?.tintColor
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        // Check if every bottons is selected with a color
        guard tableOfButtons.count > globalIndex || tableOfPinsImageView.count > globalIndex
            else {
                return
        }
        for button in tableOfButtons[globalIndex] {
            guard button.backgroundColor != UIColor.white else {
                return ;
            }
        }
        assignGuessKey(tableOfButtons[globalIndex])
        masterMindManager.calculateResult()
        assignPinColor(tableOfPinsImageView[globalIndex])
        disableButtons(tableOfButtons[globalIndex])
        // Increment the globalIndex
        globalIndex += 1
        guard tableOfButtons.count > globalIndex
            else {
                self.performSegue(withIdentifier: "goToPopUp", sender: self)
                return
        }
        enableButtons(tableOfButtons[globalIndex])
        lastReplaceButton?.setTitle("", for: .normal)
        currentSelectButton = tableOfButtons[globalIndex].first
        lastReplaceButton = currentSelectButton
        setButtonToSelectImage()
    }

    // Append all the IBoutlet Buttons
    func appendOutLetButtons() {
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
    
    // Indicate which buttons is currently selected
    func setButtonToSelectImage() {
        guard let currentSelectButton = currentSelectButton
            else {
                return
        }
        currentSelectButton.showsTouchWhenHighlighted = true
        currentSelectButton.setTitle("O", for: .normal)
        currentSelectButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        currentSelectButton.backgroundColor = UIColor.white
    }
    
    // MARK: pinImageViews func
    func appendPinImageViews() {
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
    
    // Replace the Pin image after get the number from the Manager
    func assignPinColor(_ currentRowPins: [UIImageView]) {
        var indexForNumPinColor = 0
        tableOfPinsImageView[globalIndex
        ].forEach {
            //TODO Number Not Correct
            if indexForNumPinColor < masterMindManager.black {
                $0.image = UIImage(systemName: "pin.fill")
                $0.setImageColor(color: UIColor.black)
            } else if indexForNumPinColor < masterMindManager.black + masterMindManager.white{
                $0.image = UIImage(systemName: "pin.fill")
                $0.setImageColor(color: UIColor.white)
            }
            indexForNumPinColor += 1
        }
    }
    // assigned the guesskey to the Manager
    func assignGuessKey(_ currentRowButton: [UIButton]) {
        masterMindManager.guessKey.removeAll()
        currentRowButton.forEach {
            if let color = $0.backgroundColor {
                let key = masterMindManager.getNumberFromColor(color)
                masterMindManager.guessKey.append(key)
            }
        }
    }
}

//MARK: Set extension for change UIImageView color
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
