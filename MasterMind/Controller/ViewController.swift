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
    var replaceButton : UIButton?
    var buttons : [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendOutLetButtons()
    }
    @IBAction func actionForButtons(_ sender: UIButton) {
        replaceButton = sender
        sender.showsTouchWhenHighlighted = true
        sender.setTitle("O", for: .normal)
        sender.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        sender.backgroundColor = UIColor.white
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

}

