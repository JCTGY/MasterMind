//
//  LeaderboardCell.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/11/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import UIKit

/**
Custome tableView cell for tableView in LeaderBoardViewController
*/
class LeaderboardCell: UITableViewCell {

  @IBOutlet weak var leaderboardCell: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var scoreLable: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
