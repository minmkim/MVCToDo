//
//  AddToDoController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

protocol NotesDelegate: class {
  func sendNotes(_ notes: String)
}

protocol SendDataToEventControllerDelegate: class {
  func addNewReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?)
  func editReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?, oldReminder: Reminder)
}

protocol SendDataToContextItemControllerDelegate: class {
  func addNewReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?)
  func editReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?, oldReminder: Reminder)
}

protocol SendDataToTodayViewControllerDelegate: class {
  func addNewReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?)
  func editReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?, oldReminder: Reminder)
}

class AddEditToDoController {
  
  weak var delegate: NotesDelegate?
  weak var sendDataToContextItemControllerDelegate: SendDataToContextItemControllerDelegate?
  weak var sendToEventControllerDelegate: SendDataToEventControllerDelegate?
  weak var sendDataToTodayViewControllerDelegate: SendDataToTodayViewControllerDelegate?
  var alarmTime: Date?
  var reminder: Reminder?
  var segueIdentity: String? // if coming from contextcontroller
  var contextString: String? // if need to add context label
  var todayDate = false
  
  var notes: String?
  var repeatCycleInterval: Int?
  var repeatCycle: Reminder.RepeatCycleValues?
  var repeatCustomNumber = [Int]()
  var repeatCustomRule: Reminder.RepeatCustomRuleValues?
  var endRepeatDate: Date?
  var isRepeat = false {
    didSet {
      if isRepeat == false {
        repeatCycleInterval = nil
        repeatCycle = nil
        repeatCustomNumber = []
        repeatCustomRule = nil
        endRepeatDate = nil
      }
    }
  }
  var title: String?
  
  // from adding item
  init() {
    title = "Add To Do"
  }
  
  // from editing item
  init(ItemToEdit: Reminder) {
    print("init add controller")
    title = "Edit To Do"
    reminder = ItemToEdit
    notes = reminder?.notes
    isRepeat = (reminder?.isRepeat)!
    repeatCycleInterval = reminder?.repeatCycleInterval
    repeatCycle = reminder?.repeatCycle
    repeatCustomNumber = reminder?.repeatCustomNumber ?? []
    repeatCustomRule = reminder?.repeatCustomRule
    endRepeatDate = reminder?.endRepeatDate
  }
  
  deinit {
    print("deinit add controller")
    reminder = nil
  }
  
  func donePressed(reminderTitle: String, context: String?, parent: String?, dueDate: String?, dueTime: String?, isNotify: Bool, alarmTime: Date?) {
    switch segueIdentity {
    case segueIdentifiers.editFromTodaySegue?:
      print("editfromtoday")
    case segueIdentifiers.addFromTodaySegue?:
      print("addfromtoday")
    case segueIdentifiers.addFromContextSegue?:
      if dueDate != nil {
        let date = Helper.formatStringToDate(date: dueDate!, format: dateAndTime.monthDateYear)
        sendDataToContextItemControllerDelegate?.addNewReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: date, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
      } else {
        sendDataToContextItemControllerDelegate?.addNewReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: nil, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
      }
    case segueIdentifiers.editFromContextSegue?:
      if let oldReminder = reminder {
        if dueDate != nil {
          let date = Helper.formatStringToDate(date: dueDate!, format: dateAndTime.monthDateYear)
          sendDataToContextItemControllerDelegate?.editReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: date, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate, oldReminder: oldReminder)
        } else {
          sendDataToContextItemControllerDelegate?.editReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: nil, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate, oldReminder: oldReminder)
        }
      }
    default:
      if let oldReminder = reminder {
        if dueDate != nil {
          let date = Helper.formatStringToDate(date: dueDate!, format: dateAndTime.monthDateYear)
          sendToEventControllerDelegate?.editReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: date, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate, oldReminder: oldReminder)
        } else {
          sendToEventControllerDelegate?.editReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: nil, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate, oldReminder: oldReminder)
        }
      } else {
        if dueDate != nil {
          let date = Helper.formatStringToDate(date: dueDate!, format: dateAndTime.monthDateYear)
          sendToEventControllerDelegate?.addNewReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: date, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
        } else {
          sendToEventControllerDelegate?.addNewReminder(reminderTitle: reminderTitle, context: context, parent: parent, dueDate: nil, dueTime: dueTime, notes: notes, isNotify: isNotify, alarmTime: alarmTime, isRepeat: isRepeat, repeatCycleInterval: repeatCycleInterval, repeatCycle: repeatCycle, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
        }
      }
    }
    
  }
  
  func setAlarmDate(dueDate: String, dueTime: String) {
    let dateString = Helper.formatStringToDate(date: dueDate, format: dateAndTime.monthDateYear)
    let formattedDate = Helper.formatDateToString(date: dateString, format: dateAndTime.yearMonthDay)
    alarmTime = Helper.formatDateForAlarm(dueDate: formattedDate, dueTime: dueTime)
  }
 
  func returnTodayDate() -> String {
    var dateString = ""
    if todayDate {
      let date = Date()
      dateString = Helper.formatDateToString(date: date, format: dateAndTime.monthDateYear)
    }
    return dateString
  }
  
  func setTitle() -> String {
    guard let titleString = title else {return "Add To Do"}
    return titleString
  }
}

extension AddEditToDoController: SavedNoteDelegate {
  func returnSavedNote(_ notes: String) {
    self.notes = notes
  }
}

extension AddEditToDoController: SendCustomRepeatDelegate {
  func sendCustomRepeat(repeatCycle: Reminder.RepeatCycleValues, repeatCycleInterval: Int?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?) {
    print("here")
    self.repeatCycle = repeatCycle
    self.repeatCycleInterval = repeatCycleInterval
    self.repeatCustomNumber = repeatCustomNumber
    self.repeatCustomRule = repeatCustomRule
    self.isRepeat = true
  }
  
}
