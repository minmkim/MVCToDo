//
//  TableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class EventController {
  
  let ModelController = ToDoModelController()
  var toDoDates = [String]() {
    didSet {
      toDoDates.sort(by: { (formatStringToDate(date: $0, format: "MMM dd, yyyy").compare(formatStringToDate(date: $1, format: "MMM dd, yyyy")) == .orderedAscending) })
    }
  }
  
  
  // set labels for todolist
  func cellLabelStrings(indexPath: IndexPath) -> [String] {
    var cellLabelString = [String]() // [todoitem, context, duedate]
    let date = toDoDates[indexPath.section]
    let listOfToDoForDate = ModelController.toDoList.filter( {$0.dueDate == date})
    let toDoString = listOfToDoForDate[indexPath.row].toDoItem
    let contextString = listOfToDoForDate[indexPath.row].context
    let dueString = listOfToDoForDate[indexPath.row].dueDate
    let checkedString = listOfToDoForDate[indexPath.row].checked
    let checkmarkAssetString: String
    cellLabelString.insert(toDoString, at: 0)
    cellLabelString.insert(contextString ?? "", at: 1)
    cellLabelString.insert(dueString ?? "", at: 2)
    if !checkedString {
      checkmarkAssetString = checkMarkAsset.uncheckedCircle
    } else {
      checkmarkAssetString = checkMarkAsset.checkedCircle
    }
    cellLabelString.insert(checkmarkAssetString, at: 3)
    return cellLabelString
  }
  
  // set sections and rows
  func numberOfSections() -> Int {
    toDoDates = ModelController.toDoList.flatMap( {$0.dueDate} )
    toDoDates = Array(Set(toDoDates))
    return toDoDates.count
  }
  
  func rowsPerSection(section: Int) -> Int {
    let date = toDoDates[section]
    let listOfToDoForDate = ModelController.toDoList.filter( {$0.dueDate == date})
    let rowsPerSection = listOfToDoForDate.count
    return rowsPerSection
  }
  
  func headerTitleOfSections(index: Int) -> String {
    var toDoDates = ModelController.toDoList.flatMap( {$0.dueDate} )
    toDoDates = Array(Set(toDoDates))
    return toDoDates[index]
  }
  
  func countItemsInToDoList() -> Int {
    return ModelController.toDoList.count
  }
  
  
  
  
  
  func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    guard let result = formatter.date(from: date) else {
      return formatter.date(from: "Mar 14, 1984")!
    }
    return result
  }
  
}
