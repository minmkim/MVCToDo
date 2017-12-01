//
//  ContextItemController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/27/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class ContextItemController {
  
  var toDoModelController = ToDoModelController()

  var title: String? {
    didSet {
      startCodableTestContext()
      makeContextListFromColors()
      toDoItemsInContext()
    }
  }
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  var listOfContext = ["None", "Inbox", "Home", "Work", "Personal"]
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  
  var contextToDoList = [ToDo]()
  var toDoItem: ToDo?
  
  // MARK: - tableView data
  func returnNumberOfRowsInSection() -> Int {
    return contextToDoList.count
  }
  
  func returnToDoItemForCell(_ index: Int) -> ToDo {
    let toDo = contextToDoList[index]
    return toDo
  }
  
  func checkmarkButtonPressedController(_ ID: String) -> String {
    toDoModelController = ToDoModelController()
    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
    if checkmarkIcon == true {
      return checkMarkAsset.checkedCircle
    } else {
      return checkMarkAsset.uncheckedCircle
    }
  }
  
  func returnNavigationBarColor() -> UIColor {
    guard let colorInt = listOfContextAndColors[title ?? ""] else {return colors.gray}
    let color = contextColors[colorInt]
    return color
  }
  
  func setEditingToDo(_ toDo: ToDo) {
    toDoItem = toDo
  }
  
  func returnEditingToDo() -> ToDo? {
    return toDoItem
  }
  
  func deleteItem(ID: String) {
    toDoModelController.deleteToDoItem(ID: ID)
    guard let index = contextToDoList.index(where: {$0.cloudRecordID == ID}) else {return}
    contextToDoList.remove(at: index)
  }
  
  // MARK: - Setting data
  
  func toDoItemsInContext() {
    toDoModelController = ToDoModelController()
    guard let context = title else {return}
    contextToDoList = toDoModelController.toDoList.filter({$0.context == context})
  }
  
  func makeContextListFromColors() {
    listOfContext = listOfContextAndColors.keys.map({$0})
  }
  
  func startCodableTestContext() {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Dictionary.self, from: memoryList) as [String: Int]{
        listOfContextAndColors = contextList
      }
    }
  }
  
  func saveContext() {
    //save it
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(listOfContextAndColors){
      UserDefaults.standard.set(encoded, forKey: "contextList")
    }
  }
  
  // MARK: - Formatting Dates
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
  }
}
