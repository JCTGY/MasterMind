//
//  stopPopUpViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/8/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

protocol StopPopUpViewControllerDelegate {
    // MARK: - protocol for resumimg GameTimer and stop gameSound
    
    func resumeGameTimer()
    func stopGameSound(isSound: Bool)
}

class StopPopUpViewController: UIViewController {

    let startViewController = UIApplication.shared.windows.first!.rootViewController as! StartViewController
    
    var delegate: StopPopUpViewControllerDelegate?
    var isSoundDisable: Bool?
    var isNormalMode: Bool?
    
    @IBOutlet weak var muteButtonLabel: UIButton!
    
    func displayMuteButton() {
        
        guard isSoundDisable != nil
            else {
                return
        }
        if isSoundDisable == true {
            muteButtonLabel.setTitle("Unmute", for: .normal)
        } else {
            muteButtonLabel.setTitle("Mute", for: .normal)
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayMuteButton()
    }
    
    @IBAction func resumeButton(_ sender: UIButton) {
        
        self.delegate?.resumeGameTimer()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func endGameButton(_ sender: UIButton) {
        if isNormalMode == true {
            startViewController.randomIntAPINormalMode.fetchRandomInt(isNormalMode: true)
        } else {
            startViewController.randomIntAPIHardMode.fetchRandomInt(isNormalMode: false)
        }
        startViewController.dismissStackViews()
    }
    
    @IBAction func muteButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Mute" {
            sender.setTitle("Unmute", for: .normal)
            delegate?.stopGameSound(isSound: true)
        } else {
            sender.setTitle("Mute", for: .normal)
            delegate?.stopGameSound(isSound: false)
        }
        
    }
}
