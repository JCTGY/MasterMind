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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    let masterMindManager = MasterMindManager()
    var correctKeyString: String?
    var resetGameDelegate: resetGameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendOutLetButtons()
        appendPinImageViews()
        guard let correctKeyString = correctKeyString
            else {
                return
        }
        print(correctKeyString)
        masterMindManager.assignKeyToCorrectKey(correctKeyString)
    }
    
    // MARK: - Buttons functions
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
        
        // MARK: - Increment the globalIndex
        globalIndex += 1
        if tableOfButtons.count <= globalIndex || masterMindManager.black == 4 {
            masterMindManager.scoreCalculator.calculateScore(numberOfTries: globalIndex)
            scoreLabel.text = "Score: " + masterMindManager.scoreCalculator.getFinalScore()
            self.performSegue(withIdentifier: "goToPopUp", sender: self)
        }
        enableButtons(tableOfButtons[globalIndex])
        lastReplaceButton?.setTitle("", for: .normal)
        currentSelectButton = tableOfButtons[globalIndex].first
        lastReplaceButton = currentSelectButton
        setButtonToSelectImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPopUp" {
            let destinationVC = segue.destination as! FinalPopUpViewController
            destinationVC.delegate = self
            destinationVC.gameResult = masterMindManager.getFinalResult()
        }
    }

    func appendOutLetButtons() {
        // Append all the IBoutlet Buttons
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
    }
    
    // MARK: - pinImageViews functions
    
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
    
    func assignPinColor(_ currentRowPins: [UIImageView]) {
        // Replace the Pin image after get the number from the Manager
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
    
    // MARK: - reset functions
    
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

extension GameViewController: resetGameDelegate {
    
    func didResetGame(newKey: String) {
        globalIndex = 0
        guard let firstRowButton = tableOfButtons.first
            else {
                return
        }
        enableButtons(firstRowButton)
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

extension UIImageView {
    
    // MARK: - Set extension for change UIImageView color
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
