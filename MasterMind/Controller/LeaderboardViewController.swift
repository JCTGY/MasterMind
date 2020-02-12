//
//  LeaderboardViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/11/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit
import Firebase

/**
 ## LeaderboardViewController

 Display leaderboard from firestore

 - tableview display firstore data
 - use `LeaderboardCell` to populate the tableView

 ## Warnings

 make sure use the `Constants` struct K, to acesse the dictionary form firestore
 */
class LeaderboardViewController: UIViewController {


  @IBOutlet weak var leaderboardTableView: UITableView!

  var scores: [Score] = []

  /**
   get the `StartViewController`
   - returns: StartViewController that is unwrapped but optional
   */
  func getStatViewController() -> StartViewController? {
    if let startViewController = UIApplication.shared.windows
      .first?.rootViewController as? StartViewController {
      return startViewController
    }
    return nil
  }

  /**
   fetch the data from the firestore, and populate the scores array
   the data will be fech in order of the score and have limit to 10 items
   */
  func fetchLeaderboardFromFirebase() {
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
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let backgroundImage = UIImage(named: "background_1")
      else {
        return
    }
    self.view.backgroundColor = UIColor(patternImage: backgroundImage)
    leaderboardTableView.dataSource = self
    leaderboardTableView.register(
      UINib(nibName: K.leaderboardNibName, bundle: nil),
      forCellReuseIdentifier: K.tableCellIdentifier)
    fetchLeaderboardFromFirebase()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func endGameButton(_ sender: UIButton) {
    /* end the game and back to startViewController */
    if let startViewController = getStatViewController() {
      startViewController.name = ""
      startViewController.dismissStackViews()
    }
  }
}

extension LeaderboardViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    /* return the number of tableView*/
    return scores.count
  }

  /**
   async fetching random API data
   - parameter tableView: tableView that are going to be populate
   - parameter indexPath: number row of the cell
   - returns: UITableViewCell, a tableview cell , need to populate data in there
   */
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: K.tableCellIdentifier,
      for: indexPath) as? LeaderboardCell {
      cell.nameLabel.text = scores[indexPath.row].name
      cell.scoreLable.text = "\(scores[indexPath.row].score)"
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCellIdentifier, for: indexPath)
      cell.textLabel?.text = "tableView Cell nib does not work properly"
      return cell
    }
  }
}
