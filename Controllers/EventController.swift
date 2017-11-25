//
//  TableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class EventController {
  
  lazy var toDoModelController = ToDoModelController()
  
  var toDoDatesDate = [Date]() {
    didSet {
      toDoDatesDate.sort(by: { $0.compare($1) == .orderedAscending })
      self.updateEventTableView?()
    }
  }
  var allDates = [Date]()
  
  init() {
    toDoModelController = ToDoModelController()
    setToDoDates()
    bindToDoModel()
  }
  
  var updateEventTableView: (()->())?
  
  func bindToDoModel() {
    toDoModelController.updatedEventController = { [weak self] () in
      DispatchQueue.main.async {
        self?.toDoModelController = ToDoModelController()
        print("bindToDoModel")
        self?.setToDoDates()
      }
    }
  }
  
  var toDoDates = [Date]()
  
  // set labels for todolist
  func cellLabelStrings(indexPath: IndexPath) -> ToDo {
    let date = toDoDatesDate[indexPath.section]
     let formattedDate = formatStringToDate(date: formatDateToString(date: date, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
    let toDoItem = listOfToDoForDate[indexPath.row]
    return toDoItem
  }
  
  func setToDoDates() {
    toDoModelController = ToDoModelController()
    toDoDatesDate = toDoModelController.toDoList.map( {$0.dueDate ?? Date()} ) // if duedate is nil, will set it as today. all nil items are put on today
    toDoDatesDate = toDoDatesDate.map( { formatStringToDate(date: formatDateToString(date: $0, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)  })
    toDoDatesDate = Array(Set(toDoDatesDate))
    toDoDatesDate.sort(by: { $0.compare($1) == .orderedAscending })
  }
  
  // set sections and rows
  func numberOfSections() -> Int {
    return toDoDatesDate.count
  }
  
  func rowsPerSection(section: Int) -> Int {
   toDoModelController = ToDoModelController()
    let date = toDoDatesDate[section]
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == date} )
    let rowsPerSection = listOfToDoForDate.count
    return rowsPerSection
  }
  
  func checkForItemsInDate(section: Int) -> Bool {
    toDoModelController = ToDoModelController()
    let date = toDoDatesDate[section]
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == date} )
    let rowsPerSection = listOfToDoForDate.count
    if rowsPerSection == 0 {
      return false
    } else {
      return true
    }
  }
  
  func headerTitleOfSections(index: Int) -> String {
    let date = (formatDateToString(date: toDoDatesDate[index], format: dateAndTime.headerFormat)).uppercased()
    return date
  }
  
  func checkIfToday(_ date: String) -> Bool{
    let todayDate = (calculateDate(days: 0, date: Date(), format: dateAndTime.headerFormat)).uppercased()
    if date == todayDate {
      return true
    } else {
      return false
    }
  }
  
  func sectionOfToday() -> Int {
    let index = toDoDatesDate.index(of: Date())
    return index ?? 0
  }
  
  func countItemsInToDoList() -> Int {
    toDoModelController = ToDoModelController()
    return toDoModelController.toDoList.count
  }

  func scrollToCalendarPressDate(_ Date: String) -> Int {
    let pressedDate = Date
    let datePressedDate = formatStringToDate(date: pressedDate, format: dateAndTime.monthDateYear)
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
  
  func deleteItem(ID: String) {
    toDoModelController.deleteToDoItem(ID: ID)
  }
  
  func checkmarkButtonPressedController(_ ID: String) -> String {
    toDoModelController = ToDoModelController()
    print("here2")
    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
    print(checkmarkIcon)
    if checkmarkIcon == true {
      print("asset \(checkMarkAsset.checkedCircle)")
      return checkMarkAsset.checkedCircle
    } else {
      print("asset \(checkMarkAsset.uncheckedCircle)")
      return checkMarkAsset.uncheckedCircle
    }
  }

  func calculateDate(days: Int, date: Date, format: String) -> String {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay ?? Date())
    return result
  }
  
  func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    guard let result = formatter.date(from: date) else {
      return Date()
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
