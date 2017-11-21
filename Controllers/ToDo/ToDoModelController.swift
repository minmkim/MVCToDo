//
//  ToDoModelController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class ToDoModelController {
  
  var toDoList = [ToDo]() {
    didSet {
      let defaultDate = formatStringToDate(date: "Mar 14, 1984", format: dateAndTime.monthDateYear)
      toDoList.sort( by: {!$0.checked == !$1.checked ? ($0.dueDate ?? defaultDate).compare($1.dueDate ?? defaultDate) == .orderedAscending : !$0.checked && $1.checked })
    }
  }

  
  init() {
    let toDo1 = ToDo(toDoItem: "Welcome", dueDate: formatStringToDate(date: "Dec 17, 1990", format: dateAndTime.monthDateYear), dueTime: "12:16 PM", checked: false, context: "Home", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo1")
    let toDo2 = ToDo(toDoItem: "I hope you enjoy this app!", dueDate: formatStringToDate(date: "Apr 22, 2017", format: dateAndTime.monthDateYear), dueTime: "10:30 AM", checked: true, context: "Work", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo2")
    let toDo3 = ToDo(toDoItem: "Try dragging and dropping this item to another date on the calendar", dueDate: Date(), dueTime: "", checked: false, context: "Home", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo3")
    let toDo4 = ToDo(toDoItem: "Swipe this away to delete", dueDate: Date(), dueTime: "", checked: false, context: "Personal", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo4")
    let toDo5 = ToDo(toDoItem: "Press the orange circle to complete", dueDate: Date(), dueTime: "", checked: false, context: "Inbox", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo5")
    let toDo6 = ToDo(toDoItem: "Welcome", dueDate: formatStringToDate(date: "Dec 17, 1990", format: dateAndTime.monthDateYear), dueTime: "12:16 PM", checked: false, context: "Home", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo1")
    let toDo7 = ToDo(toDoItem: "I hope you enjoy this app!", dueDate: formatStringToDate(date: "Apr 22, 2017", format: dateAndTime.monthDateYear), dueTime: "10:30 AM", checked: true, context: "Work", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo2")
    let toDo8 = ToDo(toDoItem: "Try dragging and dropping this item to another date on the calendar", dueDate: Date(), dueTime: "", checked: false, context: "Home", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo3")
    let toDo9 = ToDo(toDoItem: "Swipe this away to delete", dueDate: Date(), dueTime: "", checked: false, context: "Personal", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo4")
    let toDo10 = ToDo(toDoItem: "Press the orange circle to complete", dueDate: Date(), dueTime: "", checked: false, context: "Inbox", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo5")
    toDoList = [toDo1, toDo2, toDo3, toDo4, toDo5, toDo6, toDo7, toDo8, toDo9, toDo10]
    loadFromDisk()
  }
  
  func addNewToDoItem(toDoItem: String) {
    let uniqueReference = NSUUID().uuidString
    if let item = ToDo(toDoItem: toDoItem, cloudRecordID: uniqueReference) {
      toDoList.append(item)
    }
  }
  
  func deleteToDoItem(ID: String) {
    toDoList = toDoList.filter( {$0.cloudRecordID != ID})
  }
  
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
