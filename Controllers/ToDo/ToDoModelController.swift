//
//  ToDoModelController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit

protocol CompletedDataLoadDelegate: class {
  func setData()
}

class ToDoModelController {
  
  var remindersController: RemindersController!
  
  var toDoList = [ToDo]()
  weak var delegate: CompletedDataLoadDelegate?
  
  init() {
    remindersController = RemindersController()
    remindersController.delegate = self
    remindersController.loadReminderData { [unowned self] (calendarReminderdictionary) in
      
      for calendar in (self.remindersController.calendars) {
        for reminder in calendarReminderdictionary[calendar]! {
          var time: String?
          if reminder.dueDateComponents?.date != nil {
            time = self.formatDateToString(date: (reminder.dueDateComponents?.date)!, format: dateAndTime.hourMinute)
            if time == "12:00 AM" {
              time = ""
            }
          }
          let toDo5 = ToDo(toDoItem: reminder.title, dueDate: reminder.dueDateComponents?.date, dueTime: time, isChecked: reminder.isCompleted, context: reminder.calendar.title, notes: reminder.notes ?? "", repeatNumber: 0, repeatCycle: "", repeatDays: "", calendarRecordID: reminder.calendarItemIdentifier, notification: false, contextParent: "")
          self.toDoList.append(toDo5)
        }
      }
    }
  }
  
  func updateView() {
    delegate?.setData()
  }
  
  func addNewToDoItem(_ toDoItem: ToDo) {
    remindersController.setNewReminder(toDoItem: toDoItem)
    toDoList.append(toDoItem)
    saveToDisk()
  }
  
  func editToDoItem(_ toDoItem: ToDo) {
    remindersController.editReminder(toDoItem: toDoItem)
    guard let index = toDoList.index(where: {$0.calendarRecordID == toDoItem.calendarRecordID}) else {return}
    toDoList.remove(at: index)
    toDoList.append(toDoItem)
    saveToDisk()
  }
  
  func editToDoItemAfterDragAndDrop(ToDo: ToDo, newDueDate: String) -> Bool {
    guard let index = toDoList.index(where: {$0.calendarRecordID == ToDo.calendarRecordID}) else {return false}
    var tempToDoItem = toDoList[index]
    var isDueDateDifferent = true
    // need to fix formatting here
    if let originalDueDate = tempToDoItem.dueDate {
      let stringOriginalDueDate = formatDateToString(date: originalDueDate, format: dateAndTime.monthDateYear)
      if stringOriginalDueDate == newDueDate {
        isDueDateDifferent = false
      } else {
        isDueDateDifferent = true
      }
    } else {
      print("weird error")
    }
    
    toDoList.remove(at: index)
    // may need to fix formatting here
    tempToDoItem.dueDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
    toDoList.append(tempToDoItem)
    saveToDisk()
    return isDueDateDifferent
  }
  
  func deleteToDoItem(ID: String) {
    guard let index = toDoList.index(where: {$0.calendarRecordID == ID}) else {return}
    let toDoItem = toDoList[index]
    remindersController.removeReminder(toDoItem: toDoItem)
    toDoList.remove(at: index)
    saveToDisk()
  }
  
  func removeNotifications(ID: String, nagNumber: Int) {
//    if nagNumber != 0 {
//      notificationController.removeNagNotification(identifier: ID)
//    } else {
//      notificationController.removeNotification(identifier: ID)
//    }
  }
  
  func makeNewNotification(_ toDoItem: ToDo) {
//    let formattedDate = notificationController.formatDateAndTime(dueDate: toDoItem.dueDate!, dueTime: toDoItem.dueTime!)
//    if toDoItem.nagNumber != 0 { // if nag
//      notificationController.makeNewNagNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID, nagFrequency: toDoItem.nagNumber)
//    } else { // if no nag
//      notificationController.makeNewNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID)
//    }
  }
  
  func makeNewNotificationWithUpdatedDate(toDoItem: ToDo, newDueDate: String) {
//    let formattedNewDueDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
//    let formattedDate = notificationController.formatDateAndTime(dueDate: formattedNewDueDate, dueTime: toDoItem.dueTime!)
//
//    if toDoItem.nagNumber != 0 { // if nag
//      notificationController.makeNewNagNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID, nagFrequency: toDoItem.nagNumber)
//    } else { // if no nag
//      notificationController.makeNewNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID)
//    }
  }
  
  
  
  func checkmarkButtonPressedModel(_ ID: String) -> Bool {
    guard let index = toDoList.index(where: {$0.calendarRecordID == ID} ) else {print("no index found for checkmark")
      return false}
    let isChecked = toDoList[index].isChecked
    if !isChecked { // if unchecked
      if toDoList[index].notification {
//        removeNotifications(ID: toDoList[index].calendarRecordID, nagNumber: toDoList[index].nagNumber)
        if toDoList[index].repeatCycle == "" {
          toDoList[index].isChecked = !toDoList[index].isChecked
          saveToDisk()
          return !isChecked
        } else {
          return isChecked
        }
      } else {
        toDoList[index].isChecked = !toDoList[index].isChecked
        saveToDisk()
        return !isChecked
      }
      
    } else { // if already checked
      if toDoList[index].notification {
        makeNewNotification(toDoList[index])
      }
      toDoList[index].isChecked = !toDoList[index].isChecked
      saveToDisk()
      return !isChecked
    }
  }
  
  func checkRepeatNotification(_ ID: String) -> Bool {
    guard let index = toDoList.index(where: {$0.calendarRecordID == ID} ) else {print("no index found for checkmark")
      return false}
    var isRepeat: Bool
    if toDoList[index].repeatCycle != nil && toDoList[index].repeatCycle != "" {
      isRepeat = true
    } else {
      isRepeat = false
    }
    return isRepeat
  }
  
  func postponeNotifications(ID: String, numberHours: Int) {
    print(ID)
    print(toDoList)
    guard let index = toDoList.index(where: {$0.calendarRecordID == ID}) else {
      print("error here1")
      return
    }
    let toDoItem = toDoList[index]
    let newDateAndtime = calculateTimeAndDate(hours: numberHours)
    //removeNotifications(ID: ID, nagNumber: toDoItem.nagNumber)
    
//    if toDoItem.nagNumber != 0 { // if nag
//      notificationController.makeNewNagNotification(title: toDoItem.toDoItem, date: newDateAndtime, identifier: toDoItem.cloudRecordID, nagFrequency: toDoItem.nagNumber)
//    } else { // if no nag
//      notificationController.makeNewNotification(title: toDoItem.toDoItem, date: newDateAndtime, identifier: toDoItem.cloudRecordID)
//    }
  }
  // MARK: Date Formatting Functions
  
  func calculateDate(days: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    return newDay ?? Date()
  }
  
  func calculateTimeAndDate(hours: Int) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = "MMM dd, yyyy hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    guard let newDay = calendar.date(byAdding: .hour, value: hours, to: Date()) else {return Date()}
    return newDay
  }
  
  func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    guard let result = formatter.date(from: date) else {
      return formatter.date(from: "Mar 14, 1984")!
    }
    return result
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
  }
  
  // MARK: save and load from disk
  
  func saveToDisk() {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirectory.appendingPathComponent("ToDoList").appendingPathExtension("plist")
    
    let propertyListEncoder = PropertyListEncoder()
    let encodedNotes = try? propertyListEncoder.encode(toDoList)
    
    try? encodedNotes?.write(to: archiveURL, options: .noFileProtection)
  }
  
  func loadFromDisk() {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirectory.appendingPathComponent("ToDoList").appendingPathExtension("plist")
    let propertyListDecoder = PropertyListDecoder()
    if let retrievedNotesData = try? Data(contentsOf: archiveURL),
      let decodedNotes = try?
        propertyListDecoder.decode(Array<ToDo>.self, from: retrievedNotesData) {
      toDoList = decodedNotes
    }
  }
  func setData(_ reminder: EKReminder) -> String {
    let item = reminder.notes!.dropLast(6)
    guard let rangeOfZero = item.range(of: "{!}@#{[", options: .backwards) else {return ""}
      // Get the characters after the last 0
    let suffix = String(describing: item.suffix(from: rangeOfZero.upperBound)) // "984"
      return suffix
  }
  
  
}

extension ToDoModelController: RemindersUpdatedDelegate {
  func updateData() {
    toDoList = [ToDo]()
    remindersController.loadReminderData { [unowned self] (calendarReminderdictionary) in
      for calendar in (self.remindersController.calendars) {
        for reminder in calendarReminderdictionary[calendar]! {
          var time: String?
          if reminder.dueDateComponents?.date != nil {
            time = self.formatDateToString(date: (reminder.dueDateComponents?.date)!, format: dateAndTime.hourMinute)
            if time == "12:00 AM" {
              time = ""
            }
          }
          let toDo5 = ToDo(toDoItem: reminder.title, dueDate: reminder.dueDateComponents?.date, dueTime: time, isChecked: reminder.isCompleted, context: reminder.calendar.title, notes: reminder.notes ?? "", repeatNumber: 0, repeatCycle: "", repeatDays: "", calendarRecordID: reminder.calendarItemIdentifier, notification: false, contextParent: "")
          self.toDoList.append(toDo5)
        }
      }
      self.delegate?.setData()
    }
  }
}
