//
//  ViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/5/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class NormalGameViewController: UIViewController {

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
    var currentSelectButton: UIButton?
    var lastReplaceButton: UIButton?
    var tableRowIndex = 0
    
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
    @IBOutlet weak var timerLabel: UILabel!
    
    let masterMindManager = MasterMindManager()
    var resetGameDelegate: resetGameDelegate?
    var correctKeyString: String?
    var timer: Timer?
    var currentTime = 300
    
    func startGame() {
        
        appendtableOfButtons()
        appendtableOfPinsImageView()
        guard let correctKeyString = correctKeyString,
            let firstRowButton = tableOfButtons.first
            else {
                return
        }
        currentSelectButton = firstRowButton.first
        lastReplaceButton = firstRowButton.first
        setButtonToSelectImage()
        intitailGameTimer()
        startGameTimer()
        masterMindManager.assignKeyToCorrectKey(correctKeyString)
        masterMindManager.gameSoundController.playBackgroundSong()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startGame()
    }
    
    // MARK: - IBAction functions for buttons
    
    @IBAction func stopGameButton(_ sender: UIButton) {
        
        timer?.invalidate()
    }
    
    @IBAction func deselectColorButtons(_ sender: UIButton) {
        
        if lastReplaceButton != nil {
            lastReplaceButton?.setTitle("", for: .normal)
            lastReplaceButton?.layer.removeAllAnimations()
        }
        masterMindManager.gameSoundController.soundForPlayerSelect()
        currentSelectButton = sender
        setButtonToSelectImage()
        lastReplaceButton = sender
    }
    
    @IBAction func colorSelectButtons(_ sender: UIButton) {
        guard let currentSelectButton = currentSelectButton,
            lastReplaceButton != nil
            else {
                return
        }
        masterMindManager.gameSoundController.soundForPlayerSelect()
        currentSelectButton.backgroundColor = sender.imageView?.tintColor
        moveToNextButton()
    }
    
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
        masterMindManager.gameSoundController.soundForPlayerSubmit()
        assignGuessKey(tableOfButtons[tableRowIndex])
        masterMindManager.calculateResult()
        assignPinColor(tableOfPinsImageView[tableRowIndex])
        disableButtons(tableOfButtons[tableRowIndex])
        
        // MARK: - Increment the `tableRowIndex`
        tableRowIndex += 1
        if tableOfButtons.count <= tableRowIndex
            || masterMindManager.numberOfBlackPins == pinRowOne?.count {
            gameFinish()
        }
        enableButtons(tableOfButtons[tableRowIndex])
        lastReplaceButton?.setTitle("", for: .normal)
        currentSelectButton = tableOfButtons[tableRowIndex].first
        lastReplaceButton = currentSelectButton
        setButtonToSelectImage()
    }
    
    // MARK: - Buttons functions
    
    func appendtableOfButtons() {
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
    
    func appendtableOfPinsImageView() {
        
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
    
    // MARK: - GameTimer funtions
    
    func intitailGameTimer () {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
    }
    
    func resetGameTimer() {
        timer?.invalidate()
        currentTime = 301
        intitailGameTimer()
        startGameTimer()
    }
    
    @objc func startGameTimer() {
        currentTime -= 1
        
        if currentTime <= 0 {
            gameFinish()
        }
        timerLabel.text = "Timer: \(currentTime)"
    }
    
    func gameFinish() {
        
        timer?.invalidate()
        masterMindManager.claculateFinalScore(numberOfTries: tableRowIndex, gameTimeRemain: currentTime)
        scoreLabel.text = "Score: " + masterMindManager.scoreCalculator.getFinalScore()
        self.performSegue(withIdentifier: "goToEndPopUp", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send result to `FinalPopUpViewController`
        if segue.identifier == "goToEndPopUp" {
            let destinationVC = segue.destination as! FinalPopUpViewController
            destinationVC.delegate = self
            destinationVC.gameResult = masterMindManager.getFinalResult()
        }
        if segue.identifier == "goToStopPopUp" {
            let destinationVC = segue.destination as! StopPopUpViewController
            destinationVC.delegate = self
            destinationVC.isSoundDiable = masterMindManager.gameSoundController.disableSound
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

extension NormalGameViewController: resetGameDelegate {
    
    // MARK: - protocol call for reset `GameViewController`
    
    func didResetGame(newKey: String) {
        tableRowIndex = 0
        resetGameTimer()
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

extension NormalGameViewController: StopPopUpViewControllerDelegate {
    
    func resumeGameTimer() {
        
        intitailGameTimer()
        startGameTimer()
    }
    func stopGameSound(isSound: Bool) {
        
        if isSound == true {
            masterMindManager.gameSoundController.diableSoundPlayer()
        } else {
            masterMindManager.gameSoundController.enableSoundPlayer()
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
