//
//  ViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/5/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    var outletButtons = [[UIButton]]()
    var globalIndex = 0
    var replaceButton: UIButton?
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
    var pinUIImageViews = [[UIImageView]]()
    
    let masterMindManager = MasterMindManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendOutLetButtons()
        appendPinImageViews()
        masterMindManager.randomIntAPI.fetchRandomInt()
    }
    //MARK: Buttons func
    @IBAction func actionForButtons(_ sender: UIButton) {
        if lastReplaceButton != nil {
            lastReplaceButton?.setTitle("", for: .normal)
        }
        replaceButton = sender
        setButtonToSelectImage()
        lastReplaceButton = sender
    }
    @IBAction func colorSelectButtons(_ sender: UIButton){
        replaceButton?.backgroundColor = sender.imageView?.tintColor
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        // Check if every bottons is selected with a color
        for button in outletButtons[globalIndex] {
            guard button.backgroundColor != UIColor.white else {
                return ;
            }
        }
        assignPinColor()
        disableButtons()
        // Increment the globalIndex
        globalIndex = globalIndex < 10 ? globalIndex + 1 : globalIndex
        enableButtons()
        lastReplaceButton?.setTitle("", for: .normal)
        replaceButton = outletButtons[globalIndex][0]
        lastReplaceButton = replaceButton
        setButtonToSelectImage()
    }
    // Append all the IBoutlet Buttons
    func appendOutLetButtons() {
        outletButtons.append(rowOne!)
        outletButtons.append(rowTwo!)
        outletButtons.append(rowThree!)
        outletButtons.append(rowFour!)
        outletButtons.append(rowFive!)
        outletButtons.append(rowSix!)
        outletButtons.append(rowSeven!)
        outletButtons.append(rowEight!)
        outletButtons.append(rowNine!)
        outletButtons.append(rowTen!)
    }
    func enableButtons() {
        guard globalIndex < 10 else {
            return ;
        }
        outletButtons[globalIndex].forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    func disableButtons() {
        outletButtons[globalIndex].forEach{ $0.isUserInteractionEnabled = false
        }
    }
    // Indicate which buttons is currently selected
    func setButtonToSelectImage() {
        replaceButton?.showsTouchWhenHighlighted = true
        replaceButton?.setTitle("O", for: .normal)
        replaceButton?.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        replaceButton?.backgroundColor = UIColor.white
    }
    // MARK: pinImageViews func
    func appendPinImageViews() {
        pinUIImageViews.append(pinRowOne!)
        pinUIImageViews.append(pinRowTwo!)
        pinUIImageViews.append(pinRowThree!)
        pinUIImageViews.append(pinRowFour!)
        pinUIImageViews.append(pinRowFive!)
        pinUIImageViews.append(pinRowSix!)
        pinUIImageViews.append(pinRowSeven!)
        pinUIImageViews.append(pinRowEight!)
        pinUIImageViews.append(pinRowNine!)
        pinUIImageViews.append(pinRowTen!)
    }
    func assignPinColor() {
        var indexForNumPinColor = 0
        let tmpBlack = 2
        pinUIImageViews[globalIndex
        ].forEach {
            $0.image = UIImage(systemName: "pin.fill")
            if indexForNumPinColor < tmpBlack {
                $0.setImageColor(color: UIColor.black)
            } else {
                $0.setImageColor(color: UIColor.white)
            }
            indexForNumPinColor += 1
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

