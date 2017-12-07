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
      if toDoItem?.dueDate != nil {
        let date = formatDateToString(date: (toDoItem?.dueDate)!, format: dateAndTime.monthDateYear)
        dueDateLabel.text = date
      } else {
        dueDateLabel.text = ""
      }
    }
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
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
