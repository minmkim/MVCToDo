//
//  RepeatMonthTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/22/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class RepeatMonthTableViewCell: UITableViewCell {

  @IBOutlet var indicatorView: [UIView]!
  @IBOutlet var monthButton: [UIButton]!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
