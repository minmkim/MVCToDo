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
  @IBOutlet weak var noteImage: UIImageView!
  
  var reminder: Reminder! {
    didSet {
      if reminder.isChecked {
        checkMarkButton.setImage(UIImage(named: "CheckedCircle"), for: .normal)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: reminder.reminderTitle)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        toDoItemLabel.attributedText = attributeString
      } else {
        checkMarkButton.setImage(UIImage(named: "BlankCircle"), for: .normal)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: reminder.reminderTitle)
        toDoItemLabel.attributedText = attributeString
      }
      if let dueDate = reminder.dueDate {
        let date = Helper.formatDateToString(date: dueDate, format: dateAndTime.monthDateYear)
        dueDateLabel.text = date
      } else {
        dueDateLabel.text = ""
      }
      if reminder.notes != nil && reminder.notes != "" {
        noteImage.isHidden = false
        noteImage.image = UIImage(named: "NoteIcon")
      } else {
        noteImage.isHidden = true
      }
      checkMarkButton.setTitle(reminder.calendarRecordID, for: .normal)
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
