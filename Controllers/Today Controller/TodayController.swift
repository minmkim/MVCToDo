//
//  TodayController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol TodayTableViewDelegate: class {
  func deleteRows(_ index: IndexPath)
  func deleteSection(_ index: IndexPath)
  func beginUpdate()
  func endUpdate()
}

class TodayController {
  
  var remindersController: RemindersController!
  var delegate: TodayTableViewDelegate?
  
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  var overDueItems = [Reminder]()
  var todayItems = [Reminder]()
  var listOfContext = [[Reminder]]()
  var reminderToEdit: Reminder?
  
  init(controller: RemindersController) {
    remindersController = controller
    startCodableTestContext()
    let filteredIncompleteReminders = remindersController.incompleteReminderList.filter({$0.dueDate != nil})
    let date = Date()
    let cal: Calendar = Calendar(identifier: .gregorian)
    let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
    overDueItems = filteredIncompleteReminders.filter({$0.dueDate! < newDate})
    overDueItems = overDueItems.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
    todayItems = filteredIncompleteReminders.filter({ $0.dueDate == Date()})
    todayItems = todayItems.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
    listOfContext = [overDueItems, todayItems]
  }
  
  func returnNumberOfSections() -> Int {
    return listOfContext.count
  }

  func returnNumberOfRowInSection(_ section: Int) -> Int {
    return listOfContext[section].count
  }
  
  func returnReminderInCell(index: IndexPath) -> Reminder {
    let list = listOfContext[index.section]
    let reminder = list[index.row]
    return reminder
  }
  
  func returnContextHeader(_ section: Int) -> String {
    if section == 0 {
      return "Overdue"
    } else {
      return "Due Today"
    }
  }
  
  func setReminderToEdit(_ reminder: Reminder) {
    reminderToEdit = reminder
  }
  
  func returnEditingToDo() -> Reminder? {
    return reminderToEdit
  }
  
  func returnDueDate(_ date: Date) -> String {
    let dateString = Helper.formatDateToString(date: date, format: dateAndTime.monthDateYear)
    return dateString
  }
  
  func returnContextColor(_ context: String) -> UIColor {
    guard let colorInt = listOfContextAndColors[context] else {return .clear}
    let color = contextColors[colorInt]
    return color
  }
  
  func checkmarkButtonPressedController(_ ID: String) -> String {
//    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
//    if checkmarkIcon == true {
//      return themeController.checkedCheckmarkIcon
//    } else {
      return ""
//    }
  }
  
  func deleteItem(for reminderToDelete: Reminder, index: IndexPath) {
    let list = listOfContext[index.section]
    let newList = list.filter({$0.calendarRecordID != reminderToDelete.calendarRecordID})
    listOfContext[index.section] = newList
    remindersController.removeReminder(reminder: reminderToDelete)
    delegate?.beginUpdate()
    delegate?.deleteRows(index)
    delegate?.endUpdate()
  }
  
  func startCodableTestContext() {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Dictionary.self, from: memoryList) as [String: Int]{
        listOfContextAndColors = contextList
      }
    }
  }
}

