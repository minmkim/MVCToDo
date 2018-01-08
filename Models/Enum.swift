//
//  DateTimeEnum.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

enum dateAndTime {
  static let monthDateYear = "MMM dd, yyyy"
  static let weekMonthDateYear = "EEE MM/dd/yy"
  static let hourMinute = "hh:mm a"
  static let headerFormat = "EEE MM/dd/yy"
  static let yearMonthDay = "YYYYMMdd"
}

enum segueIdentifiers {
  static let calendarSegue = "CalendarSegue"
  static let eventSegue = "EventSegue"
  static let addToDoSegue = "AddToDoSegue"
  static let editToDoSegue = "EditToDoSegue"
  static let noteSegue = "NoteSegue"
  static let unwindNoteSegue = "UnwindWithNotesSegue"
  static let unwindContextSegue = "UnwindSegueWithContext"
  static let unwindParentSegue = "UnwindWithParent"
  static let unwindToTodayView = "UnwindToTodayView"
  static let allSegue = "AllSegue"
  static let contextItemSegue = "ContextItemSegue"
  static let addFromContextSegue = "AddFromContextSegue"
  static let editFromContextSegue = "EditFromContextItemSegue"
  static let todayViewSegue = "TodayViewSegue"
  static let editFromTodaySegue = "EditFromTodaySegue"
  static let addFromTodaySegue = "AddFromTodaySegue"
  static let customRepeatSegue = "CustomRepeatSegue"
  static let unwindWithCustomRepeatSegue = "UnwindWithCustomRepeatSegue"
  static let settingsSegue = "SettingsSegue"
}

enum checkMarkAsset {
  static let uncheckedCircle = "BlankCircle"
  static let darkUncheckedCircle = "DarkBlankCircle"
  static let checkedCircle = "CheckedCircle"
  static let darkCheckedCircle = "DarkCheckedCircle"
  static let darkAddCircle = "DarkAddCircle"
  static let addCircle = "AddCircle"
  static let repeatArrows = "RepeatArrows"
}

enum colors {
  static let red = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
  static let darkRed = UIColor(red:0.91, green:0.12, blue:0.39, alpha:1.0)
  static let purple = UIColor(red:0.61, green:0.15, blue:0.69, alpha:1.0)
  static let lightPurple = UIColor(red:0.92, green:0.50, blue:0.99, alpha:1.0)
  static let darkBlue = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
  static let lightBlue = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
  static let teal = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
  static let turqoise = UIColor(red:0.30, green:0.82, blue:0.88, alpha:1.0)
  static let hazel = UIColor(red:0.50, green:0.80, blue:0.77, alpha:1.0)
  static let green = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
  static let lightGreen = UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0)
  static let greenYellow = UIColor(red:0.83, green:0.88, blue:0.34, alpha:1.0)
  static let lightOrange = UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0)
  static let orange = UIColor(red:1.00, green:0.63, blue:0.00, alpha:1.0)
  static let darkOrange = UIColor(red:0.96, green:0.49, blue:0.00, alpha:1.0)
  static let thaddeus = UIColor(red:0.96, green:0.32, blue:0.12, alpha:1.0)
  static let brown = UIColor(red:0.43, green:0.30, blue:0.25, alpha:1.0)
  static let gray = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
}

enum lightTheme {
  static let backgroundColor = UIColor.black
  static let mainTextColor = UIColor.white
  static let headerBackgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
  static let needShadow = false
  static let navigationBarColor = UIColor.black
  static let uncheckedCheckmarkIcon = checkMarkAsset.darkUncheckedCircle
  static let checkedCheckmarkIcon = checkMarkAsset.darkCheckedCircle
  static let addCircle = checkMarkAsset.darkAddCircle
  static let addBackgroundColor = UIColor.black
  static let addTextFieldColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
}

enum darkTheme {
  static let backgroundColor = UIColor.white
  static let mainTextColor = UIColor.black
  static let headerBackgroundColor = UIColor.groupTableViewBackground
  static let needShadow = true
  static let navigationBarColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
  static let uncheckedCheckmarkIcon = checkMarkAsset.uncheckedCircle
  static let checkedCheckmarkIcon = checkMarkAsset.checkedCircle
  static let addCircle = checkMarkAsset.addCircle
  static let addBackgroundColor = UIColor.groupTableViewBackground
  static let addTextFieldColor = UIColor.white
}
