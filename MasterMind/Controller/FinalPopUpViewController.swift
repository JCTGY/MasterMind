//
//  finalPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class FinalPopUpViewController: UIViewController {

    @IBOutlet weak var finalDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tryAgainButton(_ sender: UIButton) {
        // Set to the rootViewController
        let viewController = UIApplication.shared.windows.first!.rootViewController as! StartViewController
        viewController.randomIntAPI.fetchRandomInt()
        viewController.dismissStackViews()
    }
    

}
