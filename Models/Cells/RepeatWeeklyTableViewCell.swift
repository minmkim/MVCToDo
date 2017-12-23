//
//  RepeatWeeklyTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/22/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class RepeatWeeklyTableViewCell: UITableViewCell {

  let daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  
  
  @IBOutlet weak var weekLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
