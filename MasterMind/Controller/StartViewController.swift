//
//  StartViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func startButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
}

extension StartViewController: tryAraginDelegate {
    func didClickTryButton() {
        dismiss(animated: true)
    }
}
