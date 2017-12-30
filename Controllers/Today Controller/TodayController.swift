//
//  TodayController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol TodayTableViewDelegate: class {
  func deleteRows(_ index: IndexPath)
  func deleteSection(_ index: IndexPath)
  func beginUpdate()
  func endUpdate()
  func updateTableView()
}

class TodayController {
  
  var remindersController: RemindersController!
  var delegate: TodayTableViewDelegate?
  
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  var overDueItems = [Reminder]()
  var todayItems = [Reminder]()
  var listOfContext = [[Reminder]]()
  var reminderToEdit: Reminder?
  
  init(controller: RemindersController) {
    remindersController = controller
    let filteredIncompleteReminders = remindersController.incompleteReminderList.filter({$0.dueDate != nil})
    
    let cal = Calendar(identifier: .gregorian)
    let newDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    overDueItems = filteredIncompleteReminders.filter({$0.dueDate! < newDate})
    overDueItems = overDueItems.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
    todayItems = filteredIncompleteReminders.filter({ cal.isDateInToday($0.dueDate ?? Date()) })
    todayItems = todayItems.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
    listOfContext = [overDueItems, todayItems]
  }
  
  func returnNumberOfSections() -> Int {
    return listOfContext.count
  }

  func returnNumberOfRowInSection(_ section: Int) -> Int {
    return listOfContext[section].count
  }
  
  func returnReminderInCell(index: IndexPath) -> Reminder {
    let list = listOfContext[index.section]
    let reminder = list[index.row]
    return reminder
  }
  
  func returnContextHeader(_ section: Int) -> String {
    if section == 0 {
      return "Overdue"
    } else {
      return "Due Today"
    }
  }
  
  func setReminderToEdit(_ reminder: Reminder) {
    reminderToEdit = reminder
  }
  
  func returnEditingToDo() -> Reminder? {
    return reminderToEdit
  }
  
  func returnDueDate(_ date: Date) -> String {
    let dateString = Helper.formatDateToString(date: date, format: dateAndTime.monthDateYear)
    return dateString
  }
  
  func checkmarkButtonPressedController(_ cellID: String) {
    if let reminder = remindersController.incompleteReminderList.filter({$0.calendarRecordID == cellID}).first {
      remindersController.incompleteReminderList = remindersController.incompleteReminderList.filter({$0.calendarRecordID != cellID})
      
      reminder.reminder.isCompleted = !reminder.reminder.isCompleted
      remindersController.completeReminderList.append(Reminder(reminder.reminder))
      remindersController.editReminder(reminder: reminder.reminder)
      let cal: Calendar = Calendar(identifier: .gregorian)
      let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
      if let dueDate = reminder.dueDate {
        if dueDate < newDate {
          var list = listOfContext[0]
          guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
          list[index] = Reminder(reminder.reminder)
          listOfContext[0] = list
        } else {
          var list = listOfContext[1]
          guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
          list[index] = Reminder(reminder.reminder)
          listOfContext[1] = list
        }
      }
    } else {
      guard let reminder = remindersController.completeReminderList.filter({$0.calendarRecordID == cellID}).first else {return}
      remindersController.completeReminderList = remindersController.completeReminderList.filter({$0.calendarRecordID != cellID})
      reminder.reminder.isCompleted = !reminder.reminder.isCompleted
      remindersController.incompleteReminderList.append(Reminder(reminder.reminder))
      remindersController.editReminder(reminder: reminder.reminder)
      let cal: Calendar = Calendar(identifier: .gregorian)
      let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
      if let dueDate = reminder.dueDate {
        if dueDate < newDate {
          var list = listOfContext[0]
          guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
          list[index] = Reminder(reminder.reminder)
          listOfContext[0] = list
        } else {
          var list = listOfContext[1]
          guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
          list[index] = Reminder(reminder.reminder)
          listOfContext[1] = list
        }
      }
    }
        delegate?.updateTableView()
  }
  
  func deleteItem(for reminderToDelete: Reminder, index: IndexPath) {
    let list = listOfContext[index.section]
    let newList = list.filter({$0.calendarRecordID != reminderToDelete.calendarRecordID})
    listOfContext[index.section] = newList
    remindersController.removeReminder(reminder: reminderToDelete)
    delegate?.beginUpdate()
    delegate?.deleteRows(index)
    delegate?.endUpdate()
  }
  
}

extension TodayController: SendDataToTodayViewControllerDelegate {
  func addNewReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?) {
    print("add reminder delegate")
    var newReminder = remindersController.returnReminder()
    newReminder = remindersController.createReminder(reminder: newReminder, reminderTitle: reminderTitle, dueDate: dueDate, dueTime: dueTime, context: context, parent: parent, notes: notes, notification: isNotify, notifyDate: alarmTime, isRepeat: isRepeat, repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
    remindersController.setNewReminder(ekReminder: newReminder)
    delegate?.beginUpdate()
//    if context == title {
//      if let newParent = parent {
//        if var parentList = dictionaryOfContexts[newParent] {
//          parentList.append(Reminder(newReminder))
//          dictionaryOfContexts[newParent] = parentList
//          guard let index = listOfContextHeaders.index(where: {$0 == newParent}) else {return}
//          let indexPath = IndexPath(row: (parentList.count - 1), section: index)
//          delegate?.insertRow(indexPath)
//        } else {
//          dictionaryOfContexts[newParent] = [Reminder(newReminder)]
//          listOfContextHeaders.append(newParent)
//          let indexPath = IndexPath(row: 0, section: (listOfContextHeaders.count - 1))
//          delegate?.insertSection(indexPath)
//          delegate?.insertRow(indexPath)
//        }
//      } else {
//        if var nilList = dictionaryOfContexts[""] {
//          nilList.append(Reminder(newReminder))
//          dictionaryOfContexts[""] = nilList
//          let indexPath = IndexPath(row: (nilList.count - 1), section: 0)
//          delegate?.insertRow(indexPath)
//        } else {
//          dictionaryOfContexts[""] = [Reminder(newReminder)]
//          listOfContextHeaders.insert("", at: 0)
//          let indexPath = IndexPath(row: 0, section: 0)
//          delegate?.insertSection(indexPath)
//          delegate?.insertRow(indexPath)
//        }
//      }
//    }
    delegate?.endUpdate()
  }
  
  func editReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?, oldReminder: Reminder) {
    guard let originalReminder = oldReminder.reminder else {return}
    var editedReminder = originalReminder
    editedReminder = remindersController.createReminder(reminder: originalReminder, reminderTitle: reminderTitle, dueDate: dueDate, dueTime: dueTime, context: context, parent: parent, notes: notes, notification: isNotify, notifyDate: alarmTime, isRepeat: isRepeat, repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
    remindersController.editReminder(reminder: editedReminder)
    
////    guard let oldReminder = reminder else {return}
////    delegate?.beginUpdate()
////    contextReminderList = contextReminderList.filter({$0.calendarRecordID != oldReminder.calendarRecordID})
////    if let parent = oldReminder.contextParent {
////      if var oldList = dictionaryOfContexts[parent] {
////        guard let index = oldList.index(where: {$0.calendarRecordID == oldReminder.calendarRecordID}) else {return}
////        oldList.remove(at: index)
////        guard let section = listOfContextHeaders.index(where: {$0 == parent}) else {return}
////        let indexPath = IndexPath(row: index, section: section)
////        delegate?.deleteRow(indexPath)
////        if oldList.count == 0 {
////          listOfContextHeaders.remove(at: section)
////          if listOfContextHeaders.count == 0 {
////            listOfContextHeaders.append("")
////            let newIndexPath = IndexPath(row: 0, section: 0)
////            delegate?.insertSection(newIndexPath)
////          }
////          dictionaryOfContexts[parent] = nil
////          delegate?.deleteSection(indexPath)
////        } else {
////          dictionaryOfContexts[parent] = oldList
////        }
////      }
////    } else {
////      if var oldList = dictionaryOfContexts[""] {
////        guard let index = oldList.index(where: {$0.calendarRecordID == oldReminder.calendarRecordID}) else {return}
////        oldList.remove(at: index)
////        print(oldList)
////        let indexPath = IndexPath(row: index, section: 0)
////        if oldList.count == 0 {
////          dictionaryOfContexts[""] = nil
////          if listOfContextHeaders.count == 1 {
////            listOfContextHeaders.append("")
////            delegate?.insertSection(indexPath)
////          } else {
////            listOfContextHeaders.remove(at: 0)
////          }
////          delegate?.deleteSection(indexPath)
////        } else {
////          dictionaryOfContexts[""] = oldList
////        }
////        print(indexPath)
////        delegate?.deleteRow(indexPath)
////      }
////    }
////
////    if context == title {
////      contextReminderList.append(Reminder(editedReminder))
////      if let newParent = parent {
////        if var newList = dictionaryOfContexts[newParent] {
////          newList.append(Reminder(editedReminder))
////          dictionaryOfContexts[newParent] = newList
////          let row = (newList.count - 1)
////          guard let section = listOfContextHeaders.index(where: {$0 == newParent}) else {return}
////          let indexPath = IndexPath(row: row, section: section)
////          delegate?.insertRow(indexPath)
////        } else {
////          dictionaryOfContexts[newParent] = [Reminder(editedReminder)]
////          listOfContextHeaders.append(newParent)
////          let section = (listOfContextHeaders.count - 1)
////          let indexPath = IndexPath(row: 0, section: section)
////          delegate?.insertSection(indexPath)
////          delegate?.insertRow(indexPath)
////        }
////      } else {
////        if var nilContext = dictionaryOfContexts[""] {
////          nilContext.append(Reminder(editedReminder))
////          dictionaryOfContexts[""] = nilContext
////          let row = (nilContext.count - 1)
////          let indexPath = IndexPath(row: row, section: 0)
////          delegate?.insertRow(indexPath)
////        } else {
////          dictionaryOfContexts[""] = [Reminder(editedReminder)]
////          listOfContextHeaders.insert("", at: 0)
////          let indexPath = IndexPath(row: 0, section: 0)
////          delegate?.insertSection(indexPath)
////          delegate?.insertRow(indexPath)
////        }
////      }
////    }
//    delegate?.updateTableView()
//    delegate?.endUpdate()
//  }
}
}

