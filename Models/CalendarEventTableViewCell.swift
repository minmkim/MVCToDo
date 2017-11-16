//
//  CalendarEventTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/16/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class CalendarEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
    }
}

