//
//  TableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class EventController {
  
  let toDoModelController = ToDoModelController()
  let calendarModelController = CalendarModelController()
  
  //update scroll to calendar press
  var calendarPressIndex: Int?
  
  var toDoDatesDate = [Date]() {
    didSet {
      toDoDatesDate.sort(by: { $0.compare($1) == .orderedAscending })
    }
  }
  var allDates = [Date]()
  
  init() {
    setToDoDates()
  }
  
  var toDoDates = [Date]()
  var formattedToDoDates = [Date]()
  
  // set labels for todolist
  func cellLabelStrings(indexPath: IndexPath) -> ToDo {
    let date = toDoDatesDate[indexPath.section]
     let formattedDate = formatStringToDate(date: formatDateToString(date: date, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate!, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
    let toDoItem = listOfToDoForDate[indexPath.row]
    return toDoItem
  }
  
  func setToDoDates() {
    toDoDatesDate = toDoModelController.toDoList.flatMap( {$0.dueDate} )
    toDoDatesDate = toDoDatesDate.map( { formatStringToDate(date: formatDateToString(date: $0, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)  })
    
    toDoDatesDate = Array(Set(toDoDatesDate))
    toDoDatesDate.sort(by: { $0.compare($1) == .orderedAscending })
  }
  
  // set sections and rows
  func numberOfSections() -> Int {
    return toDoDatesDate.count
  }
  
  func rowsPerSection(section: Int) -> Int {
    let date = toDoDatesDate[section]
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate!, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == date} )
    let rowsPerSection = listOfToDoForDate.count
    print("count:\(section) \(rowsPerSection)")
    return rowsPerSection
  }
  
  func headerTitleOfSections(index: Int) -> String {
    let date = (formatDateToString(date: toDoDatesDate[index], format: "EEE MM/dd/yy")).uppercased()
    return date
  }
  
  func countItemsInToDoList() -> Int {
    return toDoModelController.toDoList.count
  }

  func scrollToCalendarPressDate(_ Date: String) -> Int {
    print(calendarModelController.calendars)
    print(calendarModelController.events)
    let pressedDate = Date
    let datePressedDate = formatStringToDate(date: pressedDate, format: "MMM dd, yyyy")
    var counter = -1
    var tempSection: Int?
    for date in toDoDatesDate {
      counter += 1
      if datePressedDate <= date {
        tempSection = counter
        break
      }
    }
    guard let scrollToSection = tempSection else {return (toDoDatesDate.count - 1)}
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
