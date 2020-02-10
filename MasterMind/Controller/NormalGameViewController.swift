//
//  ViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/5/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class NormalGameViewController: BaseGameViewController {

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

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendtableOfButtons()
        appendtableOfPinsImageView()
        intitailGameTimer()
        startGameTimer()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send result to `FinalPopUpViewController`
        if segue.identifier == "goToEndPopUp" {
            let destinationVC = segue.destination as! FinalPopUpViewController
            destinationVC.delegate = self
            guard let firstPinsRow = tableOfPinsImageView.first,
                let gameStat = gameStat
                else {
                    return
            }
            destinationVC.gameStat = masterMindManager.getFinalResult(firstPinsRow.count, gameStat)
        }
        if segue.identifier == "goToStopPopUp" {
            let destinationVC = segue.destination as! StopPopUpViewController
            destinationVC.delegate = self
            destinationVC.isSoundDisable = masterMindManager.gameSoundController.disableSound
            destinationVC.isNormalMode = gameStat?.isNormalMode
        }
    }
        
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
        
        guard let firstRowPins = tableOfPinsImageView.first
            else {
                return
        }
        timer?.invalidate()
        masterMindManager.claculateFinalScore(tableRowIndex, currentTime, firstRowPins.count)
        let finalScore = masterMindManager.scoreCalculator.getFinalScore()
        scoreLabel.text = "Score: \(finalScore)"
        self.performSegue(withIdentifier: "goToEndPopUp", sender: self)
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
