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
  
  var calendarEvent: CalendarEvent? {
    didSet {
      eventLabel.text = calendarEvent?.title
      endTimeLabel.text = formatDateToString(date: calendarEvent?.end ?? Date(), format: dateAndTime.hourMinute)
      startTimeLabel.text = formatDateToString(date: calendarEvent?.dueDate ?? Date(), format: dateAndTime.hourMinute)
      locationLabel.text = calendarEvent?.location
    }
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
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