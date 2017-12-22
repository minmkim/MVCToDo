//
//  MainViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class MainViewController {
  
  var remindersController: RemindersController!
  

  var listOfContext = ["Inbox", "Home", "Work", "Personal"]
  var selectedContextIndex = 0
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  var editingContext: IndexPath?
  
  init() {
    //setContextList()
  }
  
  init(controller: RemindersController) {
    remindersController = controller
    setContextList()
  }
  
  
  func numberOfContext() -> Int {
    return listOfContext.count
  }
  
  func returnNumberOfItemInContext(_ index: Int) -> Int {
    let context = listOfContext[index]
    let filteredToDoList = remindersController.incompleteReminderList.filter({$0.context == context})
    return filteredToDoList.count
  }
  
  func returnCellNumberOfContextString(_ index: Int) -> String {
    let context = listOfContext[index]
    let filteredToDoList = remindersController.incompleteReminderList.filter({$0.context == context})
    let uncheckedContext = filteredToDoList.filter({$0.isChecked == false})
    let uncheckedContextInt = uncheckedContext.count
    if uncheckedContextInt == 0 {
      return ""
    } else {
      return String(describing: uncheckedContextInt)
    }
  }
  
  func returnCellNumberOfToday() -> String {
//    let uncheckedListOfToDo = toDoModelController.toDoList.filter({$0.isChecked == false})
//    let filteredUncheckedListOfToDo = uncheckedListOfToDo.filter({$0.dueDate != nil})
//    let date: Date = Date()
//    let cal: Calendar = Calendar(identifier: .gregorian)
    
//    let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
 //   let overDueItems = filteredUncheckedListOfToDo.filter({$0.dueDate! < newDate})
  //  let todayItems = uncheckedListOfToDo.filter({
//      formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear) == formatDateToString(date: Date(), format: dateAndTime.monthDateYear)
  //  })
  //  let count = todayItems.count + overDueItems.count
  //  return String(count)
    return ""
  }
  
  func checkIfEditing() -> Bool {
    if editingContext != nil {
      return true
    } else {
      return false
    }
  }
  
  func setCalendarColor(color: UIColor, context: String) {
    remindersController.editOrCreateCalendar(context: context, color: color)
  }
  
  func returnEditingIndexPath() -> IndexPath {
    return editingContext!
  }
  
  func setIndexPathForContextSelect(_ index: Int) {
    selectedContextIndex = index
  }
  
  func returnContextString(_ index: Int) -> String {
    return listOfContext[index]
  }
  
  func returnNewIndexPath(_ context: String) -> IndexPath {
    setContextList()
    let row = listOfContext.index(of: context)
    let indexPath = IndexPath(row: row!, section: 1)
    return indexPath
  }
  
  
  func setContextList() {
    let contextList: [String] = remindersController.calendars.flatMap({$0.title})
    listOfContext = contextList.sorted(by: {$0 < $1})
  }
  
  func returnColor(_ index: String) -> UIColor {
    guard let calendar = remindersController.calendars.filter({$0.title == index}).first else {return contextColors[11]}
    guard let color = calendar.cgColor else {return contextColors[11]}
    let uiColor = UIColor.init(cgColor: color)
    return uiColor
  }
  
  func makeContextListFromColors(_ list: [String:Int]) -> [String] {
    let newList = list.keys.map({$0})
    return newList
  }
  
}
