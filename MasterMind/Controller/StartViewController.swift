//
//  StartViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var randomIntAPINormalMode = RandomIntAPI(num: 4, min: 0, max: 7)
    var randomIntAPIHardMode = RandomIntAPI(num: 6, min: 0, max: 7)
    var correctKeyNormalMode: String?
    var correctKeyHardMode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        randomIntAPINormalMode.delegate = self
        randomIntAPINormalMode.fetchRandomInt(isNormalMode: true)
        randomIntAPIHardMode.delegate = self
        randomIntAPIHardMode.fetchRandomInt(isNormalMode: false)
    }
    
    @IBAction func startNormalModeButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToNormalMode", sender: self)
    }
    
    @IBAction func startHardModeButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToHardMode", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNormalMode" {
            let destinationVC = segue.destination as! NormalGameViewController
            guard let correctKeyNormalMode = correctKeyNormalMode
                else {
                    return
            }
            let gameStat = GameStat(correctKey: correctKeyNormalMode, isNormalMode: true)
            destinationVC.gameStat = gameStat
        }
        if segue.identifier == "goToHardMode" {
            guard let correctKeyHardMode = correctKeyHardMode
                else {
                    return
            }
            let destinationVC = segue.destination as! HardGameViewController
            let gameStat = GameStat(correctKey: correctKeyHardMode, isNormalMode: false)
            destinationVC.gameStat = gameStat
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

    func didUpdateRandomAPI(stringData: String, _ isNormalMode: Bool) {
        // async fetching random API data
        DispatchQueue.main.async {
            if isNormalMode == true {
                self.correctKeyNormalMode = stringData
            } else {
                self.correctKeyHardMode = stringData
            }
            print(stringData)
        }
    }
    func didFailWithError(error: Error) {
        // randomAPIDelegate func didFailWithError
        print(error)
    }
}
