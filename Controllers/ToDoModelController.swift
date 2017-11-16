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
      toDoList.sort( by: {!$0.checked == !$1.checked ? (formatStringToDate(date: $0.dueDate!, format: "MMM dd, yyyy")).compare(formatStringToDate(date: $1.dueDate!, format: "MMM dd, yyyy")) == .orderedAscending : !$0.checked && $1.checked })
    }
  }

  
  init() {
    let todayString = calculateDateAndFormatDateToString(days: 0, date: Date(), format: "MMM dd, yyyy")
    let toDo1 = ToDo(toDoItem: "Welcome", dueDate: "Dec 17, 1990", dueTime: "12:16 PM", checked: false, context: "Home", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo1")
    let toDo2 = ToDo(toDoItem: "I hope you enjoy this app!", dueDate: "Apr 22, 2017", dueTime: "10:30 AM", checked: true, context: "Work", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo2")
    let toDo3 = ToDo(toDoItem: "Try dragging and dropping this item to another date on the calendar", dueDate: todayString, dueTime: "", checked: false, context: "Home", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo3")
    let toDo4 = ToDo(toDoItem: "Swipe this away to delete", dueDate: todayString, dueTime: "", checked: false, context: "Personal", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo4")
    let toDo5 = ToDo(toDoItem: "Press the orange circle to complete", dueDate: todayString, dueTime: "", checked: false, context: "Inbox", notes: "", repeatNumber: nil, repeatCycle: "", nagNumber: nil, cloudRecordID: "toDo5")
    toDoList = [toDo1, toDo2, toDo3, toDo4, toDo5]
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
  
  func calculateDateAndFormatDateToString(days: Int, date: Date, format: String) -> String {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay!)
    return result
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
  
  
    
}
