//
//  ContextItemTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ContextItemTableViewCell: UITableViewCell {

  @IBOutlet weak var toDoItemLabel: UILabel!
  @IBOutlet weak var dueDateLabel: UILabel!
  @IBOutlet weak var checkMarkButton: UIButton!
  
  var toDoItem: ToDo? {
    didSet {
      toDoItemLabel.text = toDoItem?.toDoItem
      dueDateLabel.text = toDoItem?.dueTime
      if !(toDoItem?.checked)! {
        checkMarkButton.setImage(UIImage(named: checkMarkAsset.uncheckedCircle), for: .normal)
      } else {
        checkMarkButton.setImage(UIImage(named: checkMarkAsset.checkedCircle), for: .normal)
      }
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
