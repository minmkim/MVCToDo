//
//  EventTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/16/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
  
  var toDoItem: ToDo? {
    didSet {
      toDoLabel.text = toDoItem?.toDoItem
      contextLabel.text = toDoItem?.context
      dueLabel.text = toDoItem?.dueTime
      if !(toDoItem?.checked)! {
        checkmarkButton.setImage(UIImage(named: checkMarkAsset.uncheckedCircle), for: .normal)
      } else {
        checkmarkButton.setImage(UIImage(named: checkMarkAsset.checkedCircle), for: .normal)
      }
    }
  }
  
  @IBOutlet weak var toDoLabel: UILabel!
  @IBOutlet weak var contextLabel: UILabel!
  @IBOutlet weak var dueLabel: UILabel!
  
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
