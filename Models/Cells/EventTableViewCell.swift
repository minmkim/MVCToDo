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
      if toDoItem?.contextParent != "" {
        contextLabel.text = "\(toDoItem?.context ?? ""): \(toDoItem?.contextParent ?? "")"
      } else {
        contextLabel.text = toDoItem?.context
      }
      dueLabel.text = toDoItem?.dueTime
      if toDoItem?.repeatCycle != "" && (toDoItem?.notification)! && toDoItem?.isChecked == false {
        repeatCycleImage.isHidden = false
        repeatCycleImage.image = UIImage(named: checkMarkAsset.repeatArrows)
      } else {
        repeatCycleImage.isHidden = true
      }
      if toDoItem?.notes != "" {
        noteImage.isHidden = false
        noteImage.image = UIImage(named: "NoteIcon")
      } else {
        noteImage.isHidden = true
      }
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
