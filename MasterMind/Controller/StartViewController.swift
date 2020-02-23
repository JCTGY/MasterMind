//
//  StartViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/7/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

/**
## StartViewController

entry point of the game, can segue to RuleViewController, NormalGameViewController,
and HardGameViewController

- starting point of the game
- have extension `RandomAPIDelegate` to fetch correctKey

## Warnings

1. Make sure to call fetchRandomInt in the viewDidLoad so the data can properly pass to the game
2. Make sure to sign both randomAPIDelegate to self
*/
class StartViewController: UIViewController {
  var randomIntAPINormalMode = RandomIntAPI(num: 4, min: 0, max: 7)
  var randomIntAPIHardMode = RandomIntAPI(num: 6, min: 0, max: 7)
  var correctKeyNormalMode: String?
  var correctKeyHardMode: String?
  var name: String?
  var isNormal: Bool?

  @IBOutlet weak var nameTextField: UITextField!

  /**
   use `UITapGestureRecognizer` to check if player touch anywhere outside of the keyboard
   which will call `dismissKeyboard` to close the keyboard
   */
  func checkUserTabToCloseKeyboard() {
    let tap: UITapGestureRecognizer =
      UITapGestureRecognizer(target: self
        , action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    /* close the popUp keyBoard */
      view.endEditing(true)
  }

  func changeBordarStyle(_ textFiles: UITextField) {
    /* change the UIText filed board to make it look better */
    textFiles.borderStyle = UITextField.BorderStyle.roundedRect
    textFiles.layer.cornerRadius = 6.0
    textFiles.layer.masksToBounds = true
    textFiles.layer.borderColor = #colorLiteral(red: 0.515049994, green: 0.07091144472, blue: 0.1544082761, alpha: 1).cgColor
    textFiles.layer.borderWidth = 2.0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    /* Do any additional setup after loading the view. */
    checkUserTabToCloseKeyboard()
    nameTextField.delegate = self
    randomIntAPINormalMode.delegate = self
    randomIntAPINormalMode.fetchRandomInt(isNormalMode: true)
    randomIntAPIHardMode.delegate = self
    randomIntAPIHardMode.fetchRandomInt(isNormalMode: false)
    changeBordarStyle(nameTextField)
  }

  @IBAction func nameActionTextField(_ sender: UITextField) {
    /* check if the name textfied is lower that 12 character */
    checkMaxLength(textField: sender, maxLength: 12)
    name = sender.text
  }

  @IBAction func startNormalModeButton(_ sender: UIButton) {
    /* start button for Normal game mode */
    guard name != nil && name!.count > 0
      else {
        return
    }
    if sender.currentTitle == "Normal" {
      isNormal = true
    } else {
      isNormal = false
    }
    self.performSegue(withIdentifier: K.normalModeSegue, sender: self)
  }

  /**
   make sure the name is not to long
   - parameter textField: UITextField that will be check
   - parameter maxLength: the max len of name user can input
   */
  func checkMaxLength(textField: UITextField!, maxLength: Int) {
    if let currntTextLen = textField?.text?.count {
      if currntTextLen > maxLength {
        textField.deleteBackward()
      }
    }
  }

  /**
   override func the send gameStat to the next viewController either Noram/Hard
   - warning: make sure to have the correct segue.identifier
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let name = name
      else{
        return
    }
    if segue.identifier == K.normalModeSegue {
      if let destinationVC = segue.destination as? BaseGameViewController {
        if isNormal == true {
          guard let correctKeyNormalMode = correctKeyNormalMode
            else {
              return
          }
          let gameStat = GameStat(userName: name,
                                  correctKey: correctKeyNormalMode,
                                  isNormalMode: true,
                                  numOfRows: 10,
                                  numOfKeys: 4)
          destinationVC.gameStat = gameStat
        } else {
          guard let correctKeyHardMode = correctKeyHardMode
            else {
              return
          }
          let gameStat = GameStat(userName: name,
                                  correctKey: correctKeyHardMode,
                                  isNormalMode: false,
                                  numOfRows: 12,
                                  numOfKeys: 6)
          destinationVC.gameStat = gameStat
        }
      }
    }
  }

  @IBAction func ruleButton(_ sender: UIButton) {
    /* activate RuleViewController */
    self.performSegue(withIdentifier: K.ruleSegue, sender: self)
  }

  /**
   dismissSackViews will dismiss everything on top of the current view
   while will reset the game back to StartViewController
   clean up the nameTextFiled
   */
  func dismissStackViews() {
    nameTextField.text = ""
    dismiss(animated: true)
  }
}

extension StartViewController: RandomAPIDelegate {

  //MARK: delegate for randomIntAPI fetching data

  /**
   async fetching random API data
   - parameter stringData: data that did fetch from the random.org
   - parameter isNormalMode: indicate the current game mode
   */
  func didUpdateRandomAPI(stringData: String, _ isNormalMode: Bool) {
    DispatchQueue.main.async {
      if isNormalMode == true {
        self.correctKeyNormalMode = stringData
      } else {
        self.correctKeyHardMode = stringData
      }
      print(stringData)
    }
  }
  
  func didFailWithError(error: Error, _ isNormalMode: Bool) {
    /* randomAPIDelegate func didFailWithError */
    print(error)
    let localKeyGenerator = LocalRandomInt()
    if isNormalMode == true {
      self.correctKeyNormalMode = localKeyGenerator.generateLocalKey(num: 4)
      print(self.correctKeyNormalMode ?? "Normal mode key missing")
    } else {
      self.correctKeyHardMode = localKeyGenerator.generateLocalKey(num: 6)
      print(self.correctKeyHardMode ?? "Hard mode key missing")
    }
  }
}

extension StartViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.view.endEditing(true)
      return false
  }
}
