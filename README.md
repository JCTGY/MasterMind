# Mastermind
Mastermind game: a code breaking game in iOS app

![](images/MasterMind.gif)

## Objective
Implement a mastermind game, which can be played by a user who tries to guess the number combinations. On each attempt to guess the numbers of combinations, the program will provide feedback whether the player had guess a number correctly, or/and  a number and order correctly. A player must guess the right number combinations with limit attempts and limit time to win the game.

## Structure
![](images/MasterMine%20Struture.png)
- Model
  * MasterMindManager: Manager that manage the game data
  * ScoreCalulate: responsible for handling score calculation
  * GameSound: disable/enable the sound
  * GameStat: store the useful game stats
  * RandomIntAPI: fetching random key from [random.org](www.random.org)
- View
  * mainstoryboard that have five views and two pop up views
  * LeaderboardCell.xib is the template of tableView cell
- Controller
  * StartViewController: Entry point of the game can direct to Normal/Hard Game Mode
  * GameViewContrloller: viewController for both Normal/Hard game mode, contain the logic of creating correct rows of game board moving selected buttons, and game reset. Is the core of the game.
  * RuleViewController: Display the rule of the game, can be accesses from StartViewController/PausePopUpViewController
  * PausePopUpViewController: pop up view that can pase the game and change some game setting
  * FinalPopUpViewController: End of the current game. Can press continue/end game
  * LeaderboardViewController: display the leaderboard that fetch data from firestore
 
## Features    
* [How to play](#How-to-play)
* [Color/Animation](#coloranimation)
* [Normal/Hard Mode](#normalhard-mode)
* [Sounds](#Sounds)
* [Scores](#Scores)
* [Timer](#Timer)
* [Leaderboard](#Leaderboard)

## Requirements

- iOS 13.3+
- Xcode 11.3.1+
- cocoapods 1.8.4

## Installation

Install cocoapods
```
sudo gem install cocoapods
```
Clone the project and open it
```
cd ~
git clone https://github.com/JCTGY/MasterMind
cd MasterMind
open MasterMind.xcworkspace
```
Run the project by clicking play with desired iOS device 
![](images/xcode.png)

### How to play
![](images/pause.png)![](images/Score.png)![](images/Timer.png)![](images/Rule.png) \
Click on the lower circle buttons to change the color to the square buttons \
Once every color is fill, click submit to see the result \
pause button can pause the game \
When the timer runs out or player use all the tries the game is over \
![](images/PausePopUp.png)![](images/EndPopUp.png)\
Pause pop up screen can mute the sound and display a simple hint how to play the game

### Color/Animation
![](images/MasterMind.gif) \
Represent number key as differnt colors and has animation on the current select button

### Normal/Hard Mode
![](images/Color:Animation.png) ![](images/HardMode.png)\
Normal mode need to solve 4 numbers key \
Hard mode need to solve 6 numbers key
### Sounds
[GameSound](https://github.com/JCTGY/MasterMind/blob/master/MasterMind/Model/GameSound.swift) control the sound playing \
Use AVAudioPlayer to play the sound \
Game currently have backgroud soud and sound effec while clicking differnt buttons \
Can add sound when player lose or win
### Scores
[ScoreCalculate](https://github.com/JCTGY/MasterMind/blob/master/MasterMind/Model/ScoreCalulate.swift) calculate the score base on number of tries and remaining time 
```
  func calculateScore(_ numberOfTries: Int, _ gameTimeRemain: Int) {
    finalScore += 100 - (numberOfTries * 9) + (gameTimeRemain / 5)
  }
```
### Timer
Timer is display on the upper right corner. Once the timer run off the game is over

### Leaderboard
![](images/leaderboard.png) \
Use firestore to manage leaderboard. \
learderboard will show the top 15 scores
```
    let db = Firestore.firestore()
    db.collection(K.FStore.leaderboard)
      .order(by: K.FStore.score, descending: true).limit(to: 15)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          if let snapshotDocuments = querySnapshot?.documents {
            for doc in snapshotDocuments {
              let data = doc.data()
              if let name = data[K.FStore.name] as? String,
                let score = data[K.FStore.score] as? Int {
                self.scores.append(Score(name: name, score: score))
                DispatchQueue.main.async {
                  self.leaderboardTableView.reloadData()
                }
              }
            }
          }
        }
    }
```
