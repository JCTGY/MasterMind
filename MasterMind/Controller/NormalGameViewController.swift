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
    appendtableOfButtons()
    appendtableOfPinsImageView()
    startGame()
  }
}
