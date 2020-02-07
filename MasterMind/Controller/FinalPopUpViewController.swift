//
//  finalPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol tryAraginDelegate {
    func didClickTryButton()
}

class FinalPopUpViewController: UIViewController {

    @IBOutlet weak var finalDisplay: UILabel!
    var delegate: tryAraginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func tryButton(_ sender: UIButton) {
        self.delegate?.didClickTryButton()
        self.performSegue(withIdentifier: "goToStart", sender: self)
    }
    

}
