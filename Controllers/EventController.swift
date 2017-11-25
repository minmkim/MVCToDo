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
  var dragAndDropToDo: ToDo?
  var dragIndexPathOrigin: IndexPath?
  
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
    print("here3")
    toDoModelController = ToDoModelController()
    let date = toDoDatesDate[section]
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == date} )
    let rowsPerSection = listOfToDoForDate.count
    print("listOfToDoForDate: \(listOfToDoForDate)")
    if rowsPerSection == 0 {
      print("rows per section: \(rowsPerSection)")
      return true
    } else {
      return false
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
  
  func calculateIndexPath(_ newDueDate: String) -> IndexPath {
    let formattedDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
    let indexRow = listOfToDoForDate.index(where: {$0.cloudRecordID == dragAndDropToDo?.cloudRecordID})
    
    var counter = -1
    var indexSection = 0
    for date in toDoDatesDate {
      counter += 1
      if formattedDate <= date {
        indexSection = counter
        break
      }
    }
    if indexSection == -1 {
      indexSection = 0
    }
    let indexPath = IndexPath(row: indexRow!, section: indexSection)
    return indexPath
  }
  
  func needToInsertSection(_ newDueDate: String) -> Bool {
    let formattedDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
    let indexSection = toDoDatesDate.index(where: {$0 == formattedDate})
    if indexSection != nil {
      return true
    } else {
      return false
    }
  }
  
  // MARK: Drag and Drop functions
  
  func returnDragIndexPath(_ indexPath: IndexPath) {
    dragIndexPathOrigin = indexPath
  }
  
  func dragAndDropInitiated(_ ToDo: ToDo) {
    dragAndDropToDo = ToDo
  }
  
  // TODO: finish this function to update todoitem
  func updateDueDateForToDoItem(_ newDueDate: String) -> Bool {
    guard let itemToEdit = dragAndDropToDo else {return false}
    let isDueDateDifferent = toDoModelController.editToDoItemAfterDragAndDrop(ToDo: itemToEdit, newDueDate: newDueDate)
    return isDueDateDifferent
  }
  
  // MARK: Date Formatting Functions

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
