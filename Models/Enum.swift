//
//  DateTimeEnum.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

enum dateAndTime {
  static let monthDateYear = "MMM dd, yyyy"
  static let weekMonthDateYear = "EEE MM/dd/yy"
  static let hourMinute = "hh:mm a"
}

enum segueIdentifiers {
  static let calendarSegue = "CalendarSegue"
  static let eventSegue = "EventSegue"
  static let addToDoSegue = "AddToDoSegue"
  static let editToDoSegue = "EditToDoSegue"
}

enum checkMarkAsset {
  static let uncheckedCircle = "BlankCircle"
  static let darkUncheckedCircle = "DarkBlankCircle"
  static let checkedCircle = "CheckedCircle"
}
