//
//  StartViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var randomIntAPI = RandomIntAPI(num: 4, min: 0, max: 7)
    var correctKeyString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        randomIntAPI.delegate = self
        randomIntAPI.fetchRandomInt()
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let destinationVC = segue.destination as! NormalGameViewController
            destinationVC.correctKeyString = self.correctKeyString
        }
    }
    
    @IBAction func ruleButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRule", sender: self)
    }
    
    func dismissStackViews() {
        dismiss(animated: true)
    }
}

extension StartViewController: RandomAPIDelegate {
    
    //MARK: delegate for randomIntAPI fetching data

    func didUpdateRandomAPI(stringData: String) {
        // async fetching random API data
        DispatchQueue.main.async {
            self.correctKeyString = stringData
            print(stringData)
        }
    }
    func didFailWithError(error: Error) {
        // randomAPIDelegate func didFailWithError
        print(error)
    }
}
