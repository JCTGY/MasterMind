//
//  rulePopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class ruleViewController: UIViewController {

    @IBOutlet weak var ruleTextLabel: UILabel!
    
    func displayRuleText () {
        
        let attributedString = NSMutableAttributedString(string: " MasterMind\n You have ten attempts to slove the correct\n color and order\n Use lower circle button to fill color\n Once you are ready, click submit\n Black Pin = #correct color and order\n White Pin = #correct color\n You have 5 minute to slove guess the answer")
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
       // ruleTextLabel.text = ruleText
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
