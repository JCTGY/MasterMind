//
//  ViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/5/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var replaceButton : UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func rawOne(_ sender: UIButton) {
        replaceButton = sender
        sender.backgroundColor = UIColor.white
    }
    
    @IBAction func colorSelectButtons(_ sender: UIButton){
        replaceButton?.backgroundColor = sender.imageView?.tintColor
    }
    
}

