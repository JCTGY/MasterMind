//
//  LeaderboardViewController.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/11/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {


  @IBOutlet weak var leaderboardTableView: UITableView!

  var scores: [Score] = [
    Score(name: "fan", score: 13),
    Score(name: "Gakki", score: 25),
    Score(name: "lol", score: 35)
  ]
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let backgroundImage = UIImage(named: "background_1")
      else {
        return
    }
    self.view.backgroundColor = UIColor(patternImage: backgroundImage)
    leaderboardTableView.dataSource = self
    leaderboardTableView.register(UINib(nibName: K.leaderboardNibName, bundle: nil), forCellReuseIdentifier: K.tableCellIdentifier)
    // Do any additional setup after loading the view.
  }

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
  
  @IBAction func endGameButton(_ sender: UIButton) {
    if let startViewController = getStatViewController() {
    startViewController.dismissStackViews()
    }
  }
}

extension LeaderboardViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scores.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCellIdentifier, for: indexPath) as? LeaderboardCell {
      cell.nameLabel.text = "fan"
      cell.scoreLable.text = "50"
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCellIdentifier, for: indexPath)
      cell.textLabel?.text = "error"
      return cell
    }
  }


}
