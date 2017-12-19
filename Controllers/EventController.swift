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
  func updateCell(originIndex: IndexPath, updatedToDo: ToDo)
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
  var dragAndDropToDo: ToDo?
  var dragIndexPathOrigin: IndexPath?
  
  init(controller: RemindersController) {
    remindersController = controller   
    
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
    
//    for date in toDoDates {
//      let listOfReminders = remindersController.incompleteReminderList.filter({(Helper.formatDateToString(date: ($0.dueDate ?? Date()), format: dateAndTime.yearMonthDay)) == date })
//      datesRemindersList[date] = listOfReminders
//    }
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
  
//  func countItemsInToDoList() -> Int {
//    return toDoModelController.toDoList.count
//  }
  
  
  func checkForItemsInDate(section: Int) -> Bool {
    let rowsInSection = rowsPerSection(for: section)
    if rowsInSection == 0 {
      return true
    } else {
      return false
    }
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
    delegate?.deleteRow(indexPath)
    if checkForItemsInDate(section: indexPath.section) {
      setupControllerData()
      delegate?.deleteSection(indexPath)
    }
  }
  
  func checkRepeatNotification(reminder: Reminder) -> Bool {
    let repeatNotification = reminder.isRepeat
    return repeatNotification
  }
  
//  func calculatePreviousIndexPath(_ toDoItem: ToDo) -> IndexPath {
//    let date = toDoItem.dueDate!
//    let formattedDate = formatStringToDate(date: formatDateToString(date: date, format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
//    let indexSection = toDoDatesDate.index(of: formattedDate)
//    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
//    let indexRow = listOfToDoForDate.index(where: {$0.calendarRecordID == toDoItem.calendarRecordID})
//    let indexPath = IndexPath(row: indexRow!, section: indexSection!)
//    return indexPath
//  }
//  
//  func calculateNewIndexPath(toDoItem: ToDo, newDueDate: Date) -> IndexPath {
//    let formattedDate = newDueDate
//    setToDoDates()
//    let indexSection = toDoDatesDate.index(of: formattedDate)
//    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
//    let indexRow = listOfToDoForDate.index(where: {$0.calendarRecordID == toDoItem.calendarRecordID})
//    let indexPath = IndexPath(row: indexRow!, section: indexSection!)
//    return indexPath
//  }
//  
//  func checkmarkButtonPressedController(_ ID: String) -> String {
////    toDoModelController = ToDoModelController()
//    let repeatNotification = checkRepeatNotification(ID)
//    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
//    if checkmarkIcon == true {
//      return themeController.checkedCheckmarkIcon
//    } else {
//      if repeatNotification {
//        guard let toDoIndex = toDoModelController.toDoList.index(where: {$0.calendarRecordID == ID}) else {return themeController.checkedCheckmarkIcon}
//        let toDoItem = toDoModelController.toDoList[toDoIndex]
//        if toDoItem.notification {
//          updateTableView(toDoItem)
//        }
//        return themeController.uncheckedCheckmarkIcon
//      } else {
//        return themeController.uncheckedCheckmarkIcon
//      }
//    }
//  }
//
//  func updateTableView(_ toDoItem: ToDo) {
//    let formattedDueDate = formatStringToDate(date: formatDateToString(date: toDoItem.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)
//    let listOfItemsInDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDueDate} )
//    let previousIndexPath = calculatePreviousIndexPath(toDoItem)
//    let newDate = updateRepeatDueDate(toDoItem)
//    let newIndexPath = calculateNewIndexPath(toDoItem: toDoItem, newDueDate: newDate)
//    let listOfItemsInNewDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == newDate} )
//    
//    delegate?.beginUpdates()
//    delegate?.deleteRow(previousIndexPath)
//    if listOfItemsInDate.count == 1 {
//      delegate?.deleteSection(previousIndexPath)
//    }
//    if listOfItemsInNewDate.count == 1 {
//      delegate?.insertSection(newIndexPath)
//    }
//    delegate?.insertRow(newIndexPath)
//    delegate?.endUpdates()
//  }
//  
//  func updateRepeatDueDate(_ toDoItem: ToDo) -> Date {
//    guard let dueDate = toDoItem.dueDate else {return Date()}
//    guard let repeatCycle = toDoItem.repeatCycle else {return Date()}
//    let repeatInt = toDoItem.repeatNumber
//    var newDueDate: Date?
//    switch repeatCycle {
//    case "Days":
//      newDueDate = calculateDateComponent(byAdding: .day, numberOf: repeatInt, date: dueDate, format: dateAndTime.monthDateYear)
//    case "Weeks":
//      newDueDate = calculateDateComponent(byAdding: .day, numberOf: (repeatInt * 7), date: dueDate, format: dateAndTime.monthDateYear)
//    case "Months":
//      newDueDate = calculateDateComponent(byAdding: .month, numberOf: repeatInt, date: dueDate, format: dateAndTime.monthDateYear)
//    default:
//      print("error")
//    }
//    guard let newDate = newDueDate else {return Date()}
//    var newToDoItem = toDoItem
//    newToDoItem.dueDate = newDate
//    toDoModelController.editToDoItem(newToDoItem)
//    return newDate
//  }
//  
//  func calculateIndexPath(_ newDueDate: String) -> IndexPath {
//    let formattedDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
//    let listOfToDoForDate = toDoModelController.toDoList.filter( {(formatStringToDate(date: formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear), format: dateAndTime.monthDateYear)) == formattedDate})
//    let indexRow = listOfToDoForDate.index(where: {$0.calendarRecordID == dragAndDropToDo?.calendarRecordID})
//    
//    var counter = -1
//    var indexSection = 0
//    for date in toDoDatesDate {
//      counter += 1
//      if formattedDate <= date {
//        indexSection = counter
//        break
//      }
//    }
//    if indexSection == -1 {
//      indexSection = 0
//    }
//    let indexPath = IndexPath(row: indexRow!, section: indexSection)
//    return indexPath
//  }
//  
//  func needToInsertSection(_ newDueDate: String) -> Bool {
//    let formattedDate = formatStringToDate(date: newDueDate, format: dateAndTime.monthDateYear)
//    let indexSection = toDoDatesDate.index(where: {$0 == formattedDate})
//    if indexSection != nil {
//      return true
//    } else {
//      return false
//    }
//  }
  
  // MARK: Drag and Drop functions
  
  func returnDragIndexPath(_ indexPath: IndexPath) {
    dragIndexPathOrigin = indexPath
  }
  
  func dragAndDropInitiated(_ ToDo: ToDo) {
    dragAndDropToDo = ToDo
  }
  
//  func updateDueDate(_ newDate: String) {
//    let isDueDateDifferent = updateDueDateForToDoItem(newDate)
//    guard let originalIndexPath = dragIndexPathOrigin else {return}
//
//    delegate?.beginUpdates()
//    if isDueDateDifferent {
//      if checkForItemsInDate(section: originalIndexPath.section) {
//        delegate?.deleteSection(originalIndexPath)
//      }
//      setupControllerData()
//      delegate?.deleteRow(originalIndexPath)
//
//      let indexPath = calculateIndexPath(newDate)
//      if rowsPerSection(for: indexPath.section) == 1 {
//        delegate?.insertSection(indexPath)
//      }
//      delegate?.insertRow(indexPath)
//    }
//    delegate?.endUpdates()
//  }
  
//  func updateDueDateWithDropInTableView(_ endIndexPath: IndexPath) {
//    guard let originIndex = dragIndexPathOrigin else {return}
//    guard var toDoItem = dragAndDropToDo else {return}
//    let endIndex = endIndexPath
//    let numberOfItemsInOrigin = rowsPerSection(for: (originIndex.section))
//    let newDueDate = toDoDates[endIndex.section]
//    toDoItem.dueDate = newDueDate
//    toDoModelController.editToDoItem(toDoItem)
//    DispatchQueue.main.async {
//      self.delegate?.beginUpdates()
//      self.delegate?.updateCell(originIndex: originIndex, updatedToDo: toDoItem)
//      if numberOfItemsInOrigin > 1 {
////        self.toDoModelController = ToDoModelController()
//        self.delegate?.moveRowAt(originIndex: originIndex, destinationIndex: endIndex)
//        // delegate?.updateTableView()
//      } else {
//        self.delegate?.moveRowAt(originIndex: originIndex, destinationIndex: endIndex)
//
//      }
//      self.delegate?.endUpdates()
//    }
//  }
  
  // TODO: finish this function to update todoitem
//  func updateDueDateForToDoItem(_ newDueDate: String) -> Bool {
//    guard let itemToEdit = dragAndDropToDo else {return false}
//    let isDueDateDifferent = toDoModelController.editToDoItemAfterDragAndDrop(ToDo: itemToEdit, newDueDate: newDueDate)
//    return isDueDateDifferent
//  }

  
  func startCodableTestContext() {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Dictionary.self, from: memoryList) as [String: Int]{
        listOfContextAndColors = contextList
      }
    }
  }
  
  func returnDate(date: Date) -> DateComponents {
    let units: Set<Calendar.Component> = [.year, .month, .day]
    let comps = Calendar.current.dateComponents(units, from: date)
    return comps
  }
  
}

extension EventController: CompletedDataLoadDelegate {
  func setData() {
    DispatchQueue.main.async {
      self.setupControllerData()
      self.delegate?.updateTableView()
    }
    
  }
  
  
}


