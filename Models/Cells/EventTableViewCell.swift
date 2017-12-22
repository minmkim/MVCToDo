//
//  EventTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/16/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
  
  var reminder: Reminder! {
    didSet {
      toDoLabel.text = reminder.reminderTitle
      if let context = reminder.context {
        contextLabel.text = context
      } else {
        contextLabel.text = ""
      }
      if let dueTime = reminder.dueTime {
        if dueTime != "12:00 AM" || reminder.isNotification != false {
          dueLabel.text = dueTime
        } else {
          dueLabel.text = ""
        }
      } else {
        dueLabel.text = ""
      }
      if reminder.notes != nil {
        noteImage.isHidden = false
        noteImage.image = UIImage(named: "NoteIcon")
      } else {
        noteImage.isHidden = true
      }
      if reminder.isRepeat {
        repeatCycleImage.isHidden = false
        repeatCycleImage.image = UIImage(named: checkMarkAsset.repeatArrows)
      } else {
        repeatCycleImage.isHidden = true
      }
      if reminder.isChecked {
        checkmarkButton.setImage(UIImage(named: "CheckedCircle"), for: .normal)
      } else {
        checkmarkButton.setImage(UIImage(named: "BlankCircle"), for: .normal)
      }
      contextColor.backgroundColor = UIColor(cgColor: reminder.reminder.calendar.cgColor)
      contextColor.layer.cornerRadius = 3
    }
  }
  
  @IBOutlet weak var contextColor: UIView!
  @IBOutlet weak var noteImage: UIImageView!
  @IBOutlet weak var repeatCycleImage: UIImageView!
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
