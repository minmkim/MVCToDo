//
//  TableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateTableViewDelegate: class {
  func updateTableView()
  func insertRow(_ indexPath: IndexPath)
  func deleteRow(_ indexPath: IndexPath)
  func insertSection(_ indexPath: IndexPath)
  func deleteSection(_ indexPath: IndexPath)
  func moveRowAt(originIndex: IndexPath, destinationIndex: IndexPath)
  func beginUpdates()
  func endUpdates()
  func updateCell(originIndex: IndexPath, updatedReminder: Reminder)
}

class EventController {
  
  var remindersController: RemindersController!
  
  init() {
    print("init eventcontroller")
  }
  
  deinit {
    print("deinit eventcontroller")
  }
  
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  weak var delegate: UpdateTableViewDelegate?
  var toDoDates = [String]()
  var datesRemindersList = [String:[Reminder]]()
  var dragAndDropReminder: Reminder?
  var dragIndexPathOrigin: IndexPath?
  
  init(controller: RemindersController) {
    remindersController = controller   
    remindersController.remindersUpdatedDelegate = self
    remindersController.loadReminderData { [unowned self] (Reminders) in
      if !Reminders.isEmpty {
        self.setupControllerData()
        for date in (self.toDoDates) {
          autoreleasepool {
            let listOfReminders = Reminders.filter({(Helper.formatDateToString(date: ($0.dueDate ?? Date()), format: dateAndTime.yearMonthDay)) == date })
            self.datesRemindersList[date] = listOfReminders
          }
        }
        self.delegate?.updateTableView()
      }
    }
  }
  
  func setupControllerData() {
    let toDoDatesDate = remindersController.incompleteReminderList.map( {$0.dueDate ?? Date()} ) // if duedate is nil, will set it as today. all nil items are put on today
    toDoDates = toDoDatesDate.map( { Helper.formatDateToString(date: $0, format: dateAndTime.yearMonthDay)  })
    toDoDates = Array(Set(toDoDates))
    toDoDates.sort(by: { $0 < $1 })
  }
  
  func returnReminder(for indexPath: IndexPath) -> Reminder? {
    let date = toDoDates[indexPath.section]
    guard let listOfReminders = datesRemindersList[date] else {return nil}
    let reminder = listOfReminders[indexPath.row]
    return reminder
  }
  
  // set sections and rows
  func numberOfSections() -> Int {
    return toDoDates.count
  }
  
  func rowsPerSection(for section: Int) -> Int {
    let date = toDoDates[section]
    guard let listOfReminders = datesRemindersList[date] else {return 0}
    return listOfReminders.count
  }
  
  func headerTitleOfSections(for index: Int) -> String {
    let dateString = toDoDates[index]
    let dateDate = Helper.formatStringToDate(date: dateString, format: dateAndTime.yearMonthDay)
    let returnDate = Helper.formatDateToString(date: dateDate, format: dateAndTime.monthDateYear).uppercased()
    return returnDate
  }
  
  func checkIfToday(for date: String) -> Bool{
    let todayDate = Helper.calculateDate(days: 0, date: Date(), format: dateAndTime.headerFormat).uppercased()
    if date == todayDate {
      return true
    } else {
      return false
    }
  }
  
  func sectionOfToday() -> Int {
    let todayDate = Helper.formatDateToString(date: Date(), format: dateAndTime.yearMonthDay)
    let index = toDoDates.index(of: todayDate)
    return index ?? 0
  }
  
  // MARK: Control functions

  func scrollToCalendarPressDate(_ Date: String) -> Int {
    let datePressedDate = Helper.formatStringToDate(date: Date, format: dateAndTime.monthDateYear)
    let pressDateString = Helper.formatDateToString(date: datePressedDate, format: dateAndTime.yearMonthDay)
    var counter = -1
    var tempSection: Int?
    for date in toDoDates {
      counter += 1
      if pressDateString <= date {
        tempSection = counter
        break
      }
    }
    guard let scrollToSection = tempSection else {return (toDoDates.count - 1)}
    return scrollToSection
  }
  
  func deleteItem(reminder: Reminder, indexPath: IndexPath) {
    remindersController.removeReminder(reminder: reminder)
    guard var listOfreminders = datesRemindersList[Helper.formatDateToString(date: (reminder.dueDate ?? Date()), format: dateAndTime.yearMonthDay)] else {return}
    listOfreminders = listOfreminders.filter({$0.calendarRecordID != reminder.calendarRecordID})
    if listOfreminders.count == 0 && toDoDates.count == 1 {
      toDoDates.removeAll()
      delegate?.deleteSection(indexPath)
    }
    datesRemindersList[Helper.formatDateToString(date: (reminder.dueDate ?? Date()), format: dateAndTime.yearMonthDay)] = listOfreminders
    delegate?.deleteRow(indexPath)
  }
  
  func checkRepeatNotification(reminder: Reminder) -> Bool {
    let repeatNotification = reminder.isRepeat
    return repeatNotification
  }
  
  func checkmarkPressed(for cellID: String) {
    if let reminder = remindersController.incompleteReminderList.filter({$0.calendarRecordID == cellID}).first {
      remindersController.incompleteReminderList = remindersController.incompleteReminderList.filter({$0.calendarRecordID != cellID})
      
      reminder.reminder.isCompleted = !reminder.reminder.isCompleted
      remindersController.completeReminderList.append(Reminder(reminder.reminder))
      remindersController.editReminder(reminder: reminder.reminder)
      if let dueDate = reminder.dueDate {
        let dueDateString = Helper.formatDateToString(date: dueDate, format: dateAndTime.yearMonthDay)
        guard var listOfReminders = datesRemindersList[dueDateString] else {return}
        guard let index = listOfReminders.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        listOfReminders[index] = Reminder(reminder.reminder)
        datesRemindersList[dueDateString] = listOfReminders
      } else {
        let dueDateString = Helper.formatDateToString(date: Date(), format: dateAndTime.yearMonthDay)
        guard var listOfReminders = datesRemindersList[dueDateString] else {return}
        guard let index = listOfReminders.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        listOfReminders[index] = Reminder(reminder.reminder)
        datesRemindersList[dueDateString] = listOfReminders
      }
    } else {
      guard let reminder = remindersController.completeReminderList.filter({$0.calendarRecordID == cellID}).first else {return}
      remindersController.completeReminderList = remindersController.completeReminderList.filter({$0.calendarRecordID != cellID})
      reminder.reminder.isCompleted = !reminder.reminder.isCompleted
      remindersController.incompleteReminderList.append(Reminder(reminder.reminder))
      remindersController.editReminder(reminder: reminder.reminder)
      if let dueDate = reminder.dueDate {
        let dueDateString = Helper.formatDateToString(date: dueDate, format: dateAndTime.yearMonthDay)
        guard var listOfReminders = datesRemindersList[dueDateString] else {return}
        guard let index = listOfReminders.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        listOfReminders[index] = Reminder(reminder.reminder)
        datesRemindersList[dueDateString] = listOfReminders
      } else {
        let dueDateString = Helper.formatDateToString(date: Date(), format: dateAndTime.yearMonthDay)
        guard var listOfReminders = datesRemindersList[dueDateString] else {return}
        guard let index = listOfReminders.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        listOfReminders[index] = Reminder(reminder.reminder)
        datesRemindersList[dueDateString] = listOfReminders
      }
    }
    
    delegate?.updateTableView()
  }
  
  // MARK: Drag and Drop functions
  
  func returnDragIndexPath(_ indexPath: IndexPath) {
    dragIndexPathOrigin = indexPath
  }
  
  func dragAndDropInitiated(_ Reminder: Reminder) {
    dragAndDropReminder = Reminder
  }
  
  func updateDueDate(_ newDate: String) {
    guard let originalIndexPath = dragIndexPathOrigin else {return}
    guard let reminder = dragAndDropReminder else {return}
    
    if let originalDueDate = dragAndDropReminder?.dueDate {
      let originalDueDateString = Helper.formatDateToString(date: originalDueDate, format: dateAndTime.yearMonthDay)
      if newDate != originalDueDateString {
        delegate?.beginUpdates()
        guard var originalReminderList = datesRemindersList[originalDueDateString] else {return}
        guard let index = originalReminderList.index(where: {$0.calendarRecordID == dragAndDropReminder?.calendarRecordID}) else {return}
        originalReminderList.remove(at: index)
        delegate?.deleteRow(originalIndexPath)
        if originalReminderList.count == 0 {
          datesRemindersList[originalDueDateString] = nil
          guard let index = toDoDates.index(where: {$0 == originalDueDateString}) else {return}
          toDoDates.remove(at: index)
          delegate?.deleteSection(originalIndexPath)
        } else {
          datesRemindersList[originalDueDateString] = originalReminderList
        }
        let oldReminder = reminder.reminder
        let newdueDate = Helper.formatStringToDate(date: newDate, format: dateAndTime.yearMonthDay)
        if let dueTime = reminder.dueTime {
          let newDateTime = remindersController.formatDateAndTime(dueDate: newdueDate, dueTime: dueTime)
          oldReminder?.dueDateComponents = remindersController.setDateComponentsForDueDateTime(for: newDateTime)
          if reminder.isNotification {
            let newAlarm = remindersController.formatDateAndTime(dueDate: newdueDate, dueTime: dueTime)
            let newEKAlarm = remindersController.setAlarm(alarmDate: newAlarm)
            oldReminder?.alarms = [newEKAlarm]
          }
          remindersController.editReminder(reminder: oldReminder!)
          
          if var newReminderList = datesRemindersList[newDate] {
            newReminderList.insert(Reminder(oldReminder!), at: 0)
            datesRemindersList[newDate] = newReminderList
            guard let section = toDoDates.index(where: {$0 == newDate}) else {return}
            let indexPath = IndexPath(row: 0, section: section)
            delegate?.insertRow(indexPath)
          } else {
            datesRemindersList[newDate] = [Reminder(oldReminder!)]
            toDoDates.append(newDate)
            toDoDates.sort(by: { $0 < $1 })
            guard let section = toDoDates.index(where: {$0 == newDate}) else {return}
            let indexPath = IndexPath(row: 0, section: section)
            delegate?.insertSection(indexPath)
            delegate?.insertRow(indexPath)
          }
        } else {
          oldReminder?.dueDateComponents = remindersController.setDateComponentsForDueDateNoTime(for: Helper.formatStringToDate(date: newDate, format: dateAndTime.yearMonthDay))
          guard var newReminderList = datesRemindersList[newDate] else {return}
          remindersController.editReminder(reminder: oldReminder!)
          newReminderList.insert(Reminder(oldReminder!), at: 0)
          datesRemindersList[newDate] = newReminderList
          
          guard let section = toDoDates.index(where: {$0 == newDate}) else {return}
          let indexPath = IndexPath(row: 0, section: section)
          delegate?.insertRow(indexPath)
        }
      }
      delegate?.endUpdates()
    } else {
      reminder.reminder.dueDateComponents = remindersController.setDateComponentsForDueDateNoTime(for: Helper.formatStringToDate(date: newDate, format: dateAndTime.yearMonthDay))
      remindersController.editReminder(reminder: reminder.reminder)
      
      delegate?.beginUpdates()
      let originalDate = Helper.formatDateToString(date: Date(), format: dateAndTime.yearMonthDay)
      guard var originalList = datesRemindersList[originalDate] else {return}
      originalList = originalList.filter({$0.calendarRecordID != reminder.calendarRecordID})
      datesRemindersList[originalDate] = originalList
      if let newSection = toDoDates.index(where: {$0 == newDate}) {
        guard var newList = datesRemindersList[newDate] else {return}
        newList.append(Reminder(reminder.reminder))
        datesRemindersList[newDate] = newList
        let newIndexPath = IndexPath(row: (newList.count - 1), section: newSection)
        delegate?.moveRowAt(originIndex: originalIndexPath, destinationIndex: newIndexPath)
        delegate?.endUpdates()
      } else {
        datesRemindersList[newDate] = [Reminder(reminder.reminder)]
        toDoDates.append(newDate)
        toDoDates.sort(by: {$0 < $1})
        print("1")
        guard let newSection = toDoDates.index(where: {$0 == newDate}) else {return}
        let newIndexPath = IndexPath(row: 0, section: newSection)
        print("2")
        delegate?.insertSection(newIndexPath)
        delegate?.moveRowAt(originIndex: originalIndexPath, destinationIndex: newIndexPath)
        delegate?.endUpdates()
      }
    }
  }
  
  
  func updateDueDateWithDropInTableView(_ endIndexPath: IndexPath) {
    guard let originIndex = dragIndexPathOrigin else {return}
    guard let reminder = dragAndDropReminder else {return}
    let endIndex = endIndexPath
    let newDueDate = toDoDates[endIndex.section]
    
    let oldDate = toDoDates[originIndex.section]
    guard var oldList = datesRemindersList[oldDate] else {return}
    oldList.remove(at: originIndex.row)
    datesRemindersList[oldDate] = oldList
    
    guard var newList = datesRemindersList[newDueDate] else {return}
    newList.insert(Reminder(reminder.reminder), at: endIndex.row)
    datesRemindersList[newDueDate] = newList
    if let dueTime = reminder.dueTime {
      let newAlarm = remindersController.formatDateAndTime(dueDate: Helper.formatStringToDate(date: newDueDate, format: dateAndTime.yearMonthDay), dueTime: dueTime)
      reminder.reminder.dueDateComponents = remindersController.setDateComponentsForDueDateTime(for: newAlarm)
      if reminder.isNotification {
        let newEKAlarm = remindersController.setAlarm(alarmDate: newAlarm)
        reminder.reminder.alarms = [newEKAlarm]
      }
    } else {
      reminder.reminder.dueDateComponents = remindersController.setDateComponentsForDueDateNoTime(for: Helper.formatStringToDate(date: newDueDate, format: dateAndTime.yearMonthDay))
    }
    
    remindersController.editReminder(reminder: reminder.reminder)
    DispatchQueue.main.async {
      self.delegate?.beginUpdates()
      self.delegate?.updateCell(originIndex: originIndex, updatedReminder: reminder)
      self.delegate?.moveRowAt(originIndex: originIndex, destinationIndex: endIndex)
      self.delegate?.endUpdates()
    }
  }
  
  func returnDate(date: Date) -> DateComponents {
    let units: Set<Calendar.Component> = [.year, .month, .day]
    let comps = Calendar.current.dateComponents(units, from: date)
    return comps
  }
  
}

extension EventController: RemindersUpdatedDelegate {
  func updateData() {
    print("updating data")
    remindersController.loadReminderData { [unowned self] (Reminders) in
      if !Reminders.isEmpty {
        self.setupControllerData()
        for date in (self.toDoDates) {
          autoreleasepool {
            let listOfReminders = Reminders.filter({(Helper.formatDateToString(date: ($0.dueDate ?? Date()), format: dateAndTime.yearMonthDay)) == date })
            self.datesRemindersList[date] = listOfReminders
          }
        }
        self.delegate?.updateTableView()
      }
    }
  }
}

extension EventController: SendDataToEventControllerDelegate {
  
  func addNewReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?) {
    var newReminder = remindersController.returnReminder()
    newReminder = remindersController.createReminder(reminder: newReminder, reminderTitle: reminderTitle, dueDate: dueDate, dueTime: dueTime, context: context, parent: parent, notes: notes, notification: isNotify, notifyDate: alarmTime, isRepeat: isRepeat, repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
    remindersController.setNewReminder(ekReminder: newReminder)
    let date = Helper.formatDateToString(date: (dueDate ?? Date()), format: dateAndTime.yearMonthDay)
    if let _ = toDoDates.index(where: {$0 == date}) {
      if let list = datesRemindersList[date] {
        var setList = list
        setList.append(Reminder(newReminder))
        datesRemindersList[date] = setList
        delegate?.updateTableView()
      }
    } else {
      datesRemindersList[date] = [Reminder(newReminder)]
      toDoDates.append(date)
      toDoDates.sort(by: { $0 < $1 })
      delegate?.updateTableView()
    }
  }
  
  func editReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?, oldReminder: Reminder) {
    guard var originalReminder = oldReminder.reminder else {return}
    originalReminder = remindersController.createReminder(reminder: originalReminder, reminderTitle: reminderTitle, dueDate: dueDate, dueTime: dueTime, context: context, parent: parent, notes: notes, notification: isNotify, notifyDate: alarmTime, isRepeat: isRepeat, repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
    remindersController.editReminder(reminder: originalReminder)
    let date = Helper.formatDateToString(date: (dueDate ?? Date()), format: dateAndTime.yearMonthDay)
    if let _ = toDoDates.index(where: {$0 == date}) {
      if var list = datesRemindersList[date] {
        guard let index = list.index(where: {$0.calendarRecordID == originalReminder.calendarItemIdentifier}) else {return}
        list.remove(at: index)
        list.append(Reminder(originalReminder))
      }
    } else {
      guard let oldReminder = dragAndDropReminder else {return}
      guard var oldList = datesRemindersList[Helper.formatDateToString(date: dragAndDropReminder?.dueDate ?? Date(), format: dateAndTime.yearMonthDay)] else {return}
      oldList = oldList.filter({$0.calendarRecordID == oldReminder.calendarRecordID})
      datesRemindersList[Helper.formatDateToString(date: dragAndDropReminder?.dueDate ?? Date(), format: dateAndTime.yearMonthDay)] = oldList
      datesRemindersList[date] = [Reminder(originalReminder)]
      toDoDates.append(date)
      toDoDates.sort(by: { $0 < $1 })
      delegate?.updateTableView()
    }
  }
  
}
