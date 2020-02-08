//
//  stopPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol resumeGameTimerDelegate {
    
    func resumeGameTimer()
}

class stopPopUpViewController: UIViewController {

    let viewController = UIApplication.shared.windows.first!.rootViewController as! StartViewController
    
    var delegate: resumeGameTimerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewController.randomIntAPI.fetchRandomInt()
    }
    
    @IBAction func resumeButton(_ sender: UIButton) {
        
        self.delegate?.resumeGameTimer()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func endGameButton(_ sender: UIButton) {
        
        viewController.dismissStackViews()
    }
}
