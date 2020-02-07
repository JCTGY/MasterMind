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
    var masterMindManager = MasterMindManager()
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
            let destinationVC = segue.destination as! GameViewController
            destinationVC.correctKeyString = self.correctKeyString
        }
    }
    
    func dismissStackViews() {
        dismiss(animated: true)
    }
}

//MARK: delegate for randomIntAPI fetching data
extension StartViewController: RandomAPIDelegate {
    func didUpdateRandomAPI(stringData: String) {
        DispatchQueue.main.async {
            self.correctKeyString = stringData
        }
    }
    // randomAPIDelegate func didFailWithError
    func didFailWithError(error: Error) {
        print(error)
    }
}
