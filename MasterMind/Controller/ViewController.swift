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
    var outletIndex = 0
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
    let pinFillBlack = UIImage(systemName: "pin.fill")?.withTintColor(UIColor.black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendOutLetButtons()
        appendPinUIImageViews()
    }
    @IBAction func actionForButtons(_ sender: UIButton) {
        if lastReplaceButton != nil {
            lastReplaceButton?.setTitle("", for: .normal)
        }
        replaceButton = sender
        sender.showsTouchWhenHighlighted = true
        sender.setTitle("O", for: .normal)
        sender.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        sender.backgroundColor = UIColor.white
        lastReplaceButton = sender
    }
    @IBAction func colorSelectButtons(_ sender: UIButton){
        replaceButton?.setTitle("", for: .normal)
        replaceButton?.backgroundColor = sender.imageView?.tintColor
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        // Check if every bottons is selec with a color
        for button in outletButtons[outletIndex] {
            if button.backgroundColor == UIColor.white {
                return ;
            }
        }
        assignPinColor()
        disableButtons()
        outletIndex = outletIndex < 10 ? outletIndex + 1 : outletIndex
        enableButtons()
        replaceButton = outletButtons[outletIndex][0]
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
        outletButtons[outletIndex].forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    func disableButtons() {
        outletButtons[outletIndex].forEach{ $0.isUserInteractionEnabled = false
        }
    }
    func appendPinUIImageViews() {
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
        pinUIImageViews[outletIndex
        ].forEach {
            $0.image = pinFillBlack
        }
    }

}

