//
//  Constants.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/11/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

/**
## K (Constant)

storing the constant string for the game, to avoid typo

- pausePopUpSegue: segue for PausePopUpViewController
- endPopUpSegue: segue for EndPopUpViewController
- normalModeSegue: segue for NomalGameViewController
- hardModeSegue: segue for HardGameViewController
- ruleSegue: segue for RuleViewController

- SoundFileName: sound file's file Name
 - backgroud: Sound file name for background
 - select: Sound file name for selec/deselect buttons
 - submit: Sound file name for submit button

## Example

    let GameSound = GameSound()
    GameSound.playBackgroundSong()

*/

struct K {
  static let pausePopUpSegue = "goToPausePopUp"
  static let endPopUpSegue = "goToEndPopUp"
  static let normalModeSegue = "goToNormalMode"
  static let hardModeSegue = "goToHardMode"
  static let ruleSegue = "goToRule"
  static let leaderboardSegue = "goToLeaderboard"

  static let leaderboardNibName = "LeaderboardCell"
  static let tableCellIdentifier = "reuseableCell"

  struct FStore {
    static let leaderboard = "leaderboard"
    static let name = "name"
    static let score = "score"
  }

  struct SoundFileName {
    static let background = "Background"
    static let select = "playerSelect"
    static let submit = "submit"
  }
}
