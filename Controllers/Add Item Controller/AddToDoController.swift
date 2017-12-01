//
//  AddToDoController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

protocol NotesDelegate: class {
  func sendNotes(_ notes: String)
}

class AddEditToDoController {
  
  let toDoModelController = ToDoModelController()
  weak var delegate: NotesDelegate?
  
  // variables updated from view
  var nagInt = 0
  var cycleRepeatString = ""
  var numberRepeatInt = 0
  var notes = ""
  var context = ""
  var notification = false
  var isChecked = false
  
  var toDoItem: ToDo?
  var segueIdentity: String? // if coming from contextcontroller
  var contextString: String? // if need to add context label
  
  let nagListOfContext = ["Minutes"]
  let repeatingNotifications = ["Days", "Weeks", "Months"]
  let numberRepeat = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
  let numberArray = Array(1...60)
  var title: String?
  
  // from adding item
  init() {
    title = "Add To Do"
  }
  
  // from editing item
  init(ItemToEdit: ToDo) {
    title = "Edit To Do"
    toDoItem = ItemToEdit
    nagInt = toDoItem?.nagNumber ?? 0
    cycleRepeatString = toDoItem?.repeatCycle ?? ""
    numberRepeatInt = toDoItem?.repeatNumber ?? 0
    notes = toDoItem?.notes ?? ""
    print("editing: \(notes)")
    notification = toDoItem?.notification ?? false
    isChecked = toDoItem?.checked ?? false
  }
  
  func updateLabels() -> [String] {
    if let editItem = toDoItem {
      var labelStrings = [String]()
      let toDoItem = editItem.toDoItem
      let context = editItem.context ?? ""
      let notes = editItem.notes ?? ""
      let dueDate = editItem.dueDate ?? nil
      var formattedDueDate = ""
      if dueDate != nil {
        formattedDueDate = formatDateToString(date: dueDate!, format: dateAndTime.monthDateYear)
      }
      let dueTime = editItem.dueTime ?? ""
      let repeatNumber = editItem.repeatNumber
      let repeatCycle = editItem.repeatCycle ?? ""
      var repeatLabel = ""
      let temp = editItem.notification
      var notificationSwitch = ""
      if temp == true {
        notificationSwitch = "true"
      } else {
        notificationSwitch = "false"
      }
      
      if repeatNumber == 0 {
        repeatLabel = ""
      } else if repeatNumber == 1 {
        switch repeatCycle {
        case "Days":
          repeatLabel = "Every Day"
        case "Weeks":
          repeatLabel = "Every Week"
        case "Months":
          repeatLabel = "Every Month"
        default:
          repeatLabel = "Error"
        }
      } else {
        repeatLabel = "Every \(repeatNumber) \(repeatCycle)"
      }

      let nagNumber = editItem.nagNumber
      var nagText = ""
      if nagNumber == 0 {
        nagText = "None"
      } else if nagNumber == 1 {
        nagText = "Every Minute"
      } else {
        nagText = "Every \(nagNumber) Minutes"
      }
      labelStrings.append(toDoItem)
      labelStrings.append(context)
      labelStrings.append(formattedDueDate)
      labelStrings.append(dueTime)
      labelStrings.append(notes)
      labelStrings.append(repeatLabel)
      labelStrings.append(nagText)
      labelStrings.append(notificationSwitch)
      return labelStrings //[todoitem, context, duedate, duetime, notes, repeatLabel, nagText, notification]
    } else {
      return []
    }
  }
  
  func savePressed(toDo: String, context: String, dueDate: String, dueTime: String) {
    if toDoItem != nil {
      toDoItem?.toDoItem = toDo
      toDoItem?.context = context
      if dueDate != "" {
        toDoItem?.dueDate = formatStringToDate(date: dueDate, format: dateAndTime.monthDateYear)
      } else {
        toDoItem?.dueDate = nil
      }
      toDoItem?.dueTime = dueTime
      toDoItem?.repeatCycle = cycleRepeatString
      toDoItem?.repeatNumber = numberRepeatInt
      toDoItem?.nagNumber = nagInt
      toDoItem?.notes = notes
      print("notes: \(notes)")
      toDoItem?.notification = notification
      toDoModelController.editToDoItem(toDoItem!)
    } else {
      if dueDate == "" {
        let toDo = ToDo(toDoItem: toDo, dueDate: nil, dueTime: dueTime, checked: isChecked, context: context, notes: notes, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, nagNumber: nagInt, cloudRecordID: "", notification: notification)
        toDoModelController.addNewToDoItem(toDo)
      } else {
        let toDo = ToDo(toDoItem: toDo, dueDate: formatStringToDate(date: dueDate, format: dateAndTime.monthDateYear), dueTime: dueTime, checked: isChecked, context: context, notes: notes, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, nagNumber: nagInt, cloudRecordID: "", notification: notification)
        toDoModelController.addNewToDoItem(toDo)
      }
    }
  }
  
  func setContextField() -> String {
    return contextString ?? ""
  }
  
  func setTitle() -> String {
    guard let titleString = title else {return "Error"}
    return titleString
  }
  
  func setNotes() {
    delegate?.sendNotes(notes)
  }
  
  func setNotification(_ state: Bool) {
    notification = state
  }
  
  func updateContextField() -> String {
    return context
  }
  
  
  func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.date(from: date)
    return result ?? Date()
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let result = formatter.string(from: date)
    return result
  }
  
  func calculateDateMinutesAndFormatDateToString(minutes: Int, date: Date, format: String) -> String{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .minute, value: minutes, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }
  
  func calculateDateAndFormatDateToString(days: Int, date: Date, format: String) -> String{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }
}

extension AddEditToDoController: SavedNoteDelegate {
  func returnSavedNote(_ notes: String) {
    print("received Notes")
    self.notes = notes
  }
}

extension AddEditToDoController: ChosenContextDelegate {
  func sendChosenContext(_ context: String) {
    self.context = context
  }
}
