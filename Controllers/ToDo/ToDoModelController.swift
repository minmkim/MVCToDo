//
//  ToDoModelController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class ToDoModelController {
  
  var updatedEventController: (()->())?
  var toDoList = [ToDo]() {
    didSet {
      let defaultDate = formatStringToDate(date: "Mar 14, 1984", format: dateAndTime.monthDateYear)
      toDoList.sort( by: {!$0.checked == !$1.checked ? ($0.dueDate ?? defaultDate).compare($1.dueDate ?? defaultDate) == .orderedAscending : !$0.checked && $1.checked })
      self.updatedEventController?()
    }
  }
  lazy var notificationController: NotificationController = {
    NotificationController()
  }()
  
  init() {
    let toDo1 = ToDo(toDoItem: "Welcome", dueDate: formatStringToDate(date: "Dec 17, 1990", format: dateAndTime.monthDateYear), dueTime: "12:16 PM", checked: false, context: "Home", notes: "", repeatNumber: 0, repeatCycle: "", nagNumber: 0, cloudRecordID: "toDo1", notification: false)
    let toDo2 = ToDo(toDoItem: "I hope you enjoy this app!", dueDate: formatStringToDate(date: "Apr 22, 2017", format: dateAndTime.monthDateYear), dueTime: "10:30 AM", checked: true, context: "Work", notes: "", repeatNumber: 0, repeatCycle: "", nagNumber: 0, cloudRecordID: "toDo2", notification: false)
    let toDo3 = ToDo(toDoItem: "Try dragging and dropping this item to another date on the calendar", dueDate: Date(), dueTime: "", checked: false, context: "Home", notes: "", repeatNumber: 0, repeatCycle: "", nagNumber: 0, cloudRecordID: "toDo3", notification: false)
    let toDo4 = ToDo(toDoItem: "Swipe this away to delete", dueDate: Date(), dueTime: "", checked: false, context: "Personal", notes: "", repeatNumber: 0, repeatCycle: "", nagNumber: 0, cloudRecordID: "toDo4", notification: false)
    let toDo5 = ToDo(toDoItem: "Press the orange circle to complete", dueDate: Date(), dueTime: "", checked: false, context: "Inbox", notes: "", repeatNumber: 0, repeatCycle: "", nagNumber: 0, cloudRecordID: "toDo5", notification: false)
    
    toDoList = [toDo1, toDo2, toDo3, toDo4, toDo5]
    loadFromDisk()
  }
  
  func addNewToDoItem(_ toDoItem: ToDo) {
    let uniqueReference = NSUUID().uuidString
    var newItem = toDoItem
    newItem.cloudRecordID = uniqueReference
    toDoList.append(newItem)
    saveToDisk()
    print(newItem)
    if newItem.notification {
      let formattedDate = notificationController.formatDateAndTime(dueDate: newItem.dueDate!, dueTime: newItem.dueTime!)
      
      print("This is the formattedDate: \(formattedDate)")
      if newItem.nagNumber != 0 { // if nag
        notificationController.makeNewNagNotification(title: newItem.toDoItem, date: formattedDate, identifier: newItem.cloudRecordID, nagFrequency: newItem.nagNumber)
      } else { // if no nag
        notificationController.makeNewNotification(title: newItem.toDoItem, date: formattedDate, identifier: newItem.cloudRecordID)
      }
    }
  }
  
  func editToDoItem(_ toDoItem: ToDo) {
    guard let index = toDoList.index(where: {$0.cloudRecordID == toDoItem.cloudRecordID}) else {return}
    let tempToDoItem = toDoList[index]
    if tempToDoItem.notification {
      removeNotifications(ID: tempToDoItem.cloudRecordID, nagNumber: tempToDoItem.nagNumber)
    }
    
    toDoList.remove(at: index)
    toDoList.append(toDoItem)
    saveToDisk()
    
    if toDoItem.notification {
      makeNewNotification(toDoItem)
    }
  }
  
  func editToDoItemAfterDragAndDrop(ToDo: ToDo, newDueDate: String) -> Bool {
    guard let index = toDoList.index(where: {$0.cloudRecordID == ToDo.cloudRecordID}) else {return false}
    var tempToDoItem = toDoList[index]
    var isDueDateDifferent = true
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
    
    
    if tempToDoItem.notification {
      removeNotifications(ID: tempToDoItem.cloudRecordID, nagNumber: tempToDoItem.nagNumber)
      makeNewNotificationWithUpdatedDate(toDoItem: tempToDoItem, newDueDate: newDueDate)
    }
    toDoList.remove(at: index)
    tempToDoItem.dueDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
    toDoList.append(tempToDoItem)
    saveToDisk()
    return isDueDateDifferent
  }
  
  func deleteToDoItem(ID: String) {
    guard let index = toDoList.index(where: {$0.cloudRecordID == ID}) else {return}
    let toDoItem = toDoList[index]
    if toDoItem.notification {
      removeNotifications(ID: toDoItem.cloudRecordID, nagNumber: toDoItem.nagNumber)
    }
    toDoList.remove(at: index)
    saveToDisk()
  }
  
  func removeNotifications(ID: String, nagNumber: Int) {
    if nagNumber != 0 {
      notificationController.removeNagNotification(identifier: ID)
    } else {
      notificationController.removeNotification(identifier: ID)
    }
  }
  
  func makeNewNotification(_ toDoItem: ToDo) {
    let formattedDate = notificationController.formatDateAndTime(dueDate: toDoItem.dueDate!, dueTime: toDoItem.dueTime!)
    
    if toDoItem.nagNumber != 0 { // if nag
      notificationController.makeNewNagNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID, nagFrequency: toDoItem.nagNumber)
    } else { // if no nag
      notificationController.makeNewNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID)
    }
  }
  
  func makeNewNotificationWithUpdatedDate(toDoItem: ToDo, newDueDate: String) {
    let formattedNewDueDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
    let formattedDate = notificationController.formatDateAndTime(dueDate: formattedNewDueDate, dueTime: toDoItem.dueTime!)
    
    if toDoItem.nagNumber != 0 { // if nag
      notificationController.makeNewNagNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID, nagFrequency: toDoItem.nagNumber)
    } else { // if no nag
      notificationController.makeNewNotification(title: toDoItem.toDoItem, date: formattedDate, identifier: toDoItem.cloudRecordID)
    }
  }
  
  func checkmarkButtonPressedModel(_ ID: String) -> Bool {
    guard let index = toDoList.index(where: {$0.cloudRecordID == ID} ) else {print("no index found for checkmark")
      return false}
    let isChecked = toDoList[index].checked
    toDoList[index].checked = !toDoList[index].checked
    saveToDisk()
    return !isChecked
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
  
}
