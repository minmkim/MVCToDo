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
  
  var toDoModelController = ToDoModelController()
  lazy var themeController = ThemeController()
  var delegate: TodayTableViewDelegate?
  
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  var overDueItems = [ToDo]()
  var todayItems = [ToDo]()
  var listOfContext = [[ToDo]]()
  var editingToDo: ToDo?
  
  init() {
    startCodableTestContext()
    let uncheckedListOfToDo = toDoModelController.toDoList.filter({$0.isChecked == false})
    let filteredUncheckedListOfToDo = uncheckedListOfToDo.filter({$0.dueDate != nil})
    let date: Date = Date()
    let cal: Calendar = Calendar(identifier: .gregorian)
    
    let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
    overDueItems = filteredUncheckedListOfToDo.filter({$0.dueDate! < newDate})
    overDueItems = overDueItems.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
    todayItems = uncheckedListOfToDo.filter({ $0.dueDate == Date()})
    todayItems = todayItems.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
    listOfContext = [overDueItems, todayItems]
  }
  
  func returnNumberOfSections() -> Int {
    return listOfContext.count
  }

  func returnNumberOfRowInSection(_ section: Int) -> Int {
    return listOfContext[section].count
  }
  
  func returnToDoInCell(index: IndexPath) -> ToDo {
    let list = listOfContext[index.section]
    let toDoItem = list[index.row]
    return toDoItem
  }
  
  func returnContextHeader(_ section: Int) -> String {
    if section == 0 {
      return "Overdue"
    } else {
      return "Due Today"
    }
  }
  
  func setEditingToDo(_ toDoItem: ToDo) {
    editingToDo = toDoItem
  }
  
  func returnEditingToDo() -> ToDo? {
    return editingToDo
  }
  
  func returnDueDate(_ date: Date) -> String {
    let dateString = formatDateToString(date: date, format: dateAndTime.monthDateYear)
    return dateString
  }
  
  func returnContextColor(_ context: String) -> UIColor {
    guard let colorInt = listOfContextAndColors[context] else {return .clear}
    let color = contextColors[colorInt]
    return color
  }
  
  func checkmarkButtonPressedController(_ ID: String) -> String {
    toDoModelController = ToDoModelController()
    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
    if checkmarkIcon == true {
      return themeController.checkedCheckmarkIcon
    } else {
      return themeController.uncheckedCheckmarkIcon
    }
  }
  
  func deleteItem(ID: String, index: IndexPath) {
    let list = listOfContext[index.section]
    let newList = list.filter({$0.calendarRecordID != ID})
    listOfContext[index.section] = newList
    toDoModelController.deleteToDoItem(ID: ID)
    delegate?.beginUpdate()
    delegate?.deleteRows(index)
    delegate?.endUpdate()
  }

  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
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

