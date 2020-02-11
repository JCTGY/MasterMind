//
//  rulePopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit


class RuleViewController: UIViewController {
  @IBOutlet weak var ruleTextLabel: UILabel!

  func displayRuleText () {
    /* display the Rule in the RuleViewController lable */
    let attributedString = NSMutableAttributedString(string: " MasterMind\n You have ten attempts to solve the correct\n color and order\n Use lower circle button to fill color\n Once you are ready, click submit\n Black Pin = #correct color and order\n White Pin = #correct color\n You have 5 minute to solve guess the answer")
    let paragraphStyle = NSMutableParagraphStyle()

    paragraphStyle.lineSpacing = 8
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    ruleTextLabel.attributedText = attributedString
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    guard let backgroundImage = UIImage(named: "background_1")
      else {
        return
    }
    self.view.backgroundColor = UIColor(patternImage: backgroundImage)
    displayRuleText()
  }

  @IBAction func backButton(_ sender: UIButton) {
    /* dismiss the RuleController View */
    dismiss(animated: true, completion: nil)
  }
}
