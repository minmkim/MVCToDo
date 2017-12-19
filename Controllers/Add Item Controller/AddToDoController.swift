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
  
  weak var delegate: NotesDelegate?
  
  var reminder: Reminder?
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
  init(ItemToEdit: Reminder) {
    print("init add controller")
    title = "Edit To Do"
    reminder = ItemToEdit
  }
  
  deinit {
    print("deinit add controller")
    reminder = nil
  }
  
  func savePressed(toDo: String, context: String, dueDate: String, dueTime: String) {
//    if toDoItem != nil {
//      print("here1")
//      toDoItem?.toDoItem = toDo
//      toDoItem?.context = context
//      if dueDate != "" {
//        toDoItem?.dueDate = formatStringToDate(date: dueDate, format: dateAndTime.monthDateYear)
//      } else {
//        toDoItem?.dueDate = nil
//      }
//      toDoItem?.dueTime = dueTime
//      toDoItem?.repeatCycle = cycleRepeatString
//      toDoItem?.repeatNumber = numberRepeatInt
//      toDoItem?.notes = notes
//      toDoItem?.notification = notification
//      toDoItem?.contextParent = parent
////      toDoModelController.editToDoItem(toDoItem!)
//    } else {
//      print("here2")
//      if dueDate == "" {
//        let toDo = ToDo(toDoItem: toDo, dueDate: nil, dueTime: nil, isChecked: isChecked, context: context, notes: notes, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, repeatDays: "", calendarRecordID: "", notification: notification, contextParent: parent)
////        toDoModelController.addNewToDoItem(toDo)
//      } else {
//        print("here3")
//        let toDo = ToDo(toDoItem: toDo, dueDate: formatStringToDate(date: dueDate, format: dateAndTime.monthDateYear), dueTime: dueTime, isChecked: isChecked, context: context, notes: notes, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, repeatDays: "", calendarRecordID: "", notification: notification, contextParent: parent)
////        toDoModelController.addNewToDoItem(toDo)
//      }
//    }
  }
  
  func returnTodayDate() -> String {
    var dateString = ""
    if todayDate {
      let date = Date()
      dateString = Helper.formatDateToString(date: date, format: dateAndTime.monthDateYear)
    }
    return dateString
  }
  
  func setTitle() -> String {
    guard let titleString = title else {return "Add To Do"}
    return titleString
  }
}

extension AddEditToDoController: SavedNoteDelegate {
  func returnSavedNote(_ notes: String) {
  //  self.notes = notes
  }
}

extension AddEditToDoController: ChosenContextDelegate {
  func sendChosenContext(_ context: String) {
    if context == "None" {
//      self.context = ""
//      self.parent = ""
//    } else {
//      self.context = context
      //    }
    }
  }
}

extension AddEditToDoController: ChosenParentDelegate {
  func returnChosenParent(_ parent: String) {
//    self.parent = parent
  }
}

