//
//  TableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class EventController {
  
  let ModelController = ToDoModelController()
  var calendarPressIndex: Int?
  
  var toDoDatesString = [String]() {
    didSet {
      toDoDatesString.sort(by: { (formatStringToDate(date: $0, format: "MMM dd, yyyy").compare(formatStringToDate(date: $1, format: "MMM dd, yyyy")) == .orderedAscending) })
    }
  }
  
  init() {
    setToDoDates()
    print("event controller Hello")
  }
  
  var toDoDates = [Date]()
  
  
  // set labels for todolist
  func cellLabelStrings(indexPath: IndexPath) -> [String] {
    var cellLabelString = [String]() // [todoitem, context, duedate]
    let date = toDoDatesString[indexPath.section]
    let listOfToDoForDate = ModelController.toDoList.filter( {$0.dueDate == date})
    let toDoString = listOfToDoForDate[indexPath.row].toDoItem
    let contextString = listOfToDoForDate[indexPath.row].context
    let dueString = listOfToDoForDate[indexPath.row].dueTime
    let checkedString = listOfToDoForDate[indexPath.row].checked
    let checkmarkAssetString: String
    cellLabelString.insert(toDoString, at: 0)
    cellLabelString.insert(contextString ?? "", at: 1)
    cellLabelString.insert(dueString ?? "", at: 2)
    if !checkedString {
      checkmarkAssetString = checkMarkAsset.uncheckedCircle
    } else {
      checkmarkAssetString = checkMarkAsset.checkedCircle
    }
    cellLabelString.insert(checkmarkAssetString, at: 3)
    return cellLabelString
  }
  
  func setToDoDates() {
    toDoDatesString = ModelController.toDoList.flatMap( {$0.dueDate} )
    toDoDatesString = Array(Set(toDoDatesString))
    toDoDatesString.sort(by: { (formatStringToDate(date: $0, format: "MMM dd, yyyy").compare(formatStringToDate(date: $1, format: "MMM dd, yyyy")) == .orderedAscending) })
    for date in toDoDatesString {
      toDoDates.append(formatStringToDate(date: date, format: "MM/dd/yy"))
    }
  }
  
  // set sections and rows
  func numberOfSections() -> Int {
    return toDoDatesString.count
  }
  
  func rowsPerSection(section: Int) -> Int {
    let date = toDoDatesString[section]
    let listOfToDoForDate = ModelController.toDoList.filter( {$0.dueDate == date})
    let rowsPerSection = listOfToDoForDate.count
    return rowsPerSection
  }
  
  func headerTitleOfSections(index: Int) -> String {
    let date = (formatDateToString(date: toDoDates[index], format: "EEE MM/dd/yy")).uppercased()
    return date
  }
  
  func countItemsInToDoList() -> Int {
    return ModelController.toDoList.count
  }

  func scrollToCalendarPressDate(_ Date: String) -> Int {
    let pressedDate = Date
    let datePressedDate = formatStringToDate(date: pressedDate, format: "MMM dd, yyyy")
    var counter = -1
    var tempSection: Int?
    for date in toDoDatesString {
      counter += 1
      if datePressedDate <= formatStringToDate(date: date, format: "MMM dd, yyyy") {
        print(pressedDate)
        print(formatStringToDate(date: date, format: "MMM dd, yyyy"))
        tempSection = counter
        break
      }
    }
    guard let scrollToSection = tempSection else {return (toDoDatesString.count - 1)}
    return scrollToSection
  }

  func calculateDate(days: Int, date: Date, format: String) -> String {
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
