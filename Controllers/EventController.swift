//
//  TableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

protocol UpdateTableViewDelegate: class {
  func updateTableView()
  func insertRow(_ indexPath: IndexPath)
  func deleteRow(_ indexPath: IndexPath)
  func insertSection(_ indexPath: IndexPath)
  func deleteSection(_ indexPath: IndexPath)
  func moveRowAt(originIndex: IndexPath, destinationIndex: IndexPath)
  func beginUpdates()
  func endUpdates()
}

class EventController {
  
  lazy var toDoModelController = ToDoModelController()
  var themeController = ThemeController()
  
  var delegate: UpdateTableViewDelegate?
  var toDoDatesDate = [Date]() {
    didSet {
      toDoDatesDate.sort(by: { $0.compare($1) == .orderedAscending })
    }
  }
  var dragAndDropToDo: ToDo?
  var dragIndexPathOrigin: IndexPath?
  
  init() {
    toDoModelController = ToDoModelController()
    setToDoDates()
  }
  
  var toDoDates = [Date]()
  
  func setToDoDates() {
    toDoModelController = ToDoModelController()
    toDoDatesDate = toDoModelController.toDoList.map( {$0.dueDate ?? Date()} ) // if duedate is nil, will set it as today. all nil items are put on today
    toDoDatesDate = toDoDatesDate.map( { formatStringToDate(date: formatDateToString(date: $0, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)  })
    toDoDatesDate = Array(Set(toDoDatesDate))
    toDoDatesDate.sort(by: { $0.compare($1) == .orderedAscending })
  }
  
  // MARK: tableview Data Source
  func cellLabelStrings(indexPath: IndexPath) -> ToDo {
    let date = toDoDatesDate[indexPath.section]
     let formattedDate = formatStringToDate(date: formatDateToString(date: date, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
    let toDoItem = listOfToDoForDate[indexPath.row]
    return toDoItem
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
  
  
  func checkForItemsInDate(section: Int) -> Bool {
    toDoModelController = ToDoModelController()
    let date = toDoDatesDate[section]
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == date} )
    let rowsPerSection = listOfToDoForDate.count
    if rowsPerSection == 0 {
      return true
    } else {
      return false
    }
  }
  
  // MARK: Control functions

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
  
  func deleteItem(ID: String, indexPath: IndexPath) {
    toDoModelController.deleteToDoItem(ID: ID)
    delegate?.deleteRow(indexPath)
    if checkForItemsInDate(section: indexPath.section) {
      setToDoDates()
      delegate?.deleteSection(indexPath)
    }
  }
  
  func checkRepeatNotification(_ ID: String) -> Bool {
    toDoModelController = ToDoModelController()
    let repeatNotification = toDoModelController.checkRepeatNotification(ID)
    return repeatNotification
  }
  
  func calculatePreviousIndexPath(_ toDoItem: ToDo) -> IndexPath {
    let date = toDoItem.dueDate!
    let formattedDate = formatStringToDate(date: formatDateToString(date: date, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
    let indexSection = toDoDatesDate.index(of: formattedDate)
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
    let indexRow = listOfToDoForDate.index(where: {$0.cloudRecordID == toDoItem.cloudRecordID})
    let indexPath = IndexPath(row: indexRow!, section: indexSection!)
    return indexPath
  }
  
  func calculateNewIndexPath(toDoItem: ToDo, newDueDate: Date) -> IndexPath {
    let formattedDate = newDueDate
    setToDoDates()
    let indexSection = toDoDatesDate.index(of: formattedDate)
    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
    let indexRow = listOfToDoForDate.index(where: {$0.cloudRecordID == toDoItem.cloudRecordID})
    let indexPath = IndexPath(row: indexRow!, section: indexSection!)
    return indexPath
  }
  
  func checkmarkButtonPressedController(_ ID: String) -> String {
    toDoModelController = ToDoModelController()
    let repeatNotification = checkRepeatNotification(ID)
    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
    if checkmarkIcon == true {
      return themeController.checkedCheckmarkIcon
    } else {
      if repeatNotification {
        guard let toDoIndex = toDoModelController.toDoList.index(where: {$0.cloudRecordID == ID}) else {return themeController.checkedCheckmarkIcon}
        let toDoItem = toDoModelController.toDoList[toDoIndex]
        if toDoItem.notification {
          updateTableView(toDoItem)
        }
        return themeController.uncheckedCheckmarkIcon
      } else {
        return themeController.uncheckedCheckmarkIcon
      }
    }
  }

  func updateTableView(_ toDoItem: ToDo) {
    let formattedDueDate = formatStringToDate(date: formatDateToString(date: toDoItem.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
    let listOfItemsInDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDueDate} )
    let previousIndexPath = calculatePreviousIndexPath(toDoItem)
    let newDate = updateRepeatDueDate(toDoItem)
    let newIndexPath = calculateNewIndexPath(toDoItem: toDoItem, newDueDate: newDate)
    let listOfItemsInNewDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == newDate} )
    
    delegate?.beginUpdates()
    delegate?.deleteRow(previousIndexPath)
    if listOfItemsInDate.count == 1 {
      delegate?.deleteSection(previousIndexPath)
    }
    if listOfItemsInNewDate.count == 1 {
      delegate?.insertSection(newIndexPath)
    }
    delegate?.insertRow(newIndexPath)
    delegate?.endUpdates()
  }
  
  func updateRepeatDueDate(_ toDoItem: ToDo) -> Date {
    guard let dueDate = toDoItem.dueDate else {return Date()}
    guard let repeatCycle = toDoItem.repeatCycle else {return Date()}
    let repeatInt = toDoItem.repeatNumber
    var newDueDate: Date?
    switch repeatCycle {
    case "Days":
      newDueDate = calculateDateComponent(byAdding: .day, numberOf: repeatInt, date: dueDate, format: dateAndTime.monthDateYear)
    case "Weeks":
      newDueDate = calculateDateComponent(byAdding: .day, numberOf: (repeatInt * 7), date: dueDate, format: dateAndTime.monthDateYear)
    case "Months":
      newDueDate = calculateDateComponent(byAdding: .month, numberOf: repeatInt, date: dueDate, format: dateAndTime.monthDateYear)
    default:
      print("error")
    }
    guard let newDate = newDueDate else {return Date()}
    var newToDoItem = toDoItem
    newToDoItem.dueDate = newDate
    toDoModelController.editToDoItem(newToDoItem)
    return newDate
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
  
  func updateDueDate(_ newDate: String) {
    let isDueDateDifferent = updateDueDateForToDoItem(newDate)
    guard let originalIndexPath = dragIndexPathOrigin else {return}
    
    delegate?.beginUpdates()
    if isDueDateDifferent {
      if checkForItemsInDate(section: originalIndexPath.section) {
        delegate?.deleteSection(originalIndexPath)
      }
      setToDoDates()
      delegate?.deleteRow(originalIndexPath)
      
      let indexPath = calculateIndexPath(newDate)
      if rowsPerSection(section: indexPath.section) == 1 {
        delegate?.insertSection(indexPath)
      }
      delegate?.insertRow(indexPath)
    }
    delegate?.endUpdates()
  }
  
  func updateDueDateWithDropInTableView(_ endIndexPath: IndexPath) {
    guard let originIndex = dragIndexPathOrigin else {return}
    guard var toDoItem = dragAndDropToDo else {return}
    let endIndex = endIndexPath
    let numberOfItemsInOrigin = rowsPerSection(section: (originIndex.section))
    let newDueDate = toDoDatesDate[endIndex.section]
    toDoItem.dueDate = newDueDate
    toDoModelController.editToDoItem(toDoItem)
    DispatchQueue.main.async {
      self.delegate?.beginUpdates()
      if numberOfItemsInOrigin > 1 {
        print("updating from here")
        self.toDoModelController = ToDoModelController()
        self.delegate?.moveRowAt(originIndex: originIndex, destinationIndex: endIndex)
        // delegate?.updateTableView()
      } else {
        print("updating from here2")
        //self.delegate?.deleteSection(originIndex)
    //    self.setToDoDates()
        self.delegate?.moveRowAt(originIndex: originIndex, destinationIndex: endIndex)
        
      }
      self.delegate?.endUpdates()
    }
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
  
  func calculateDateComponent(byAdding: Calendar.Component, numberOf: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: byAdding, value: numberOf, to: date)
    return newDay ?? Date()
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
