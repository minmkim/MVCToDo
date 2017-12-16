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
  
  var toDoModelController: ToDoModelController!
  weak var delegate: NotesDelegate?
  
  // variables updated from view
  var nagInt = 0
  var cycleRepeatString = ""
  var numberRepeatInt = 0
  var notes = ""
  var context = ""
  var notification = false
  var isChecked = false
  var parent = ""
  
  var toDoItem: ToDo?
  var segueIdentity: String? // if coming from contextcontroller
  var contextString: String? // if need to add context label
  var todayDate = false
  
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
    cycleRepeatString = toDoItem?.repeatCycle ?? ""
    numberRepeatInt = toDoItem?.repeatNumber ?? 0
    notes = toDoItem?.notes ?? ""
    print("editing: \(notes)")
    notification = toDoItem?.notification ?? false
    isChecked = toDoItem?.isChecked ?? false
    parent = toDoItem?.contextParent ?? ""
  }
  
  func updateLabels() -> [String] {
    if let editItem = toDoItem {
      var labelStrings = [String]()
      let toDoItem = editItem.toDoItem
      let context = editItem.context ?? ""
      let parent = editItem.contextParent
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

      labelStrings.append(toDoItem)
      labelStrings.append(context)
      labelStrings.append(formattedDueDate)
      labelStrings.append(dueTime)
      labelStrings.append(parent)
      labelStrings.append(repeatLabel)
      labelStrings.append(notificationSwitch)
      return labelStrings //[todoitem, context, duedate, duetime, parent, repeatLabel, nagText, notification]
    } else {
      return []
    }
  }
  
  func savePressed(toDo: String, context: String, dueDate: String, dueTime: String) {
    if toDoItem != nil {
      print("here1")
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
      toDoItem?.notes = notes
      toDoItem?.notification = notification
      toDoItem?.contextParent = parent
      toDoModelController.editToDoItem(toDoItem!)
    } else {
      print("here2")
      if dueDate == "" {
        let toDo = ToDo(toDoItem: toDo, dueDate: nil, dueTime: nil, isChecked: isChecked, context: context, notes: notes, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, repeatDays: "", calendarRecordID: "", notification: notification, contextParent: parent)
        toDoModelController.addNewToDoItem(toDo)
      } else {
        print("here3")
        let toDo = ToDo(toDoItem: toDo, dueDate: formatStringToDate(date: dueDate, format: dateAndTime.monthDateYear), dueTime: dueTime, isChecked: isChecked, context: context, notes: notes, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, repeatDays: "", calendarRecordID: "", notification: notification, contextParent: parent)
        toDoModelController.addNewToDoItem(toDo)
      }
    }
  }
  
  func setContextField() -> String {
    return contextString ?? ""
  }
  
  func returnTodayDate() -> String {
    var dateString = ""
    if todayDate {
      let date = Date()
      dateString = formatDateToString(date: date, format: dateAndTime.monthDateYear)
    }
    return dateString
  }
  
  func setTitle() -> String {
    guard let titleString = title else {return "Add To Do"}
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
  
  func updateParentField() -> String {
    print("setting: \(parent)")
    return parent
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
    self.notes = notes
  }
}

extension AddEditToDoController: ChosenContextDelegate {
  func sendChosenContext(_ context: String) {
    if context == "None" {
      self.context = ""
      self.parent = ""
    } else {
      self.context = context
    }
  }
}

extension AddEditToDoController: ChosenParentDelegate {
  func returnChosenParent(_ parent: String) {
    print("received: \(parent)")
    self.parent = parent
  }
}
