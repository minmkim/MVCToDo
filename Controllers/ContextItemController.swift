//
//  ContextItemController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/27/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class ContextItemController {
  
  var toDoModelController = ToDoModelController()

  var title: String? {
    didSet {
      startCodableTestContext()
      toDoItemsInContext()
    }
  }
  var listOfContext = ["None", "Inbox", "Home", "Work", "Personal"]
  var contextToDoList = [ToDo]()
  
  // MARK: - tableView data
  func returnNumberOfRowsInSection() -> Int {
    return contextToDoList.count
  }
  
  func returnToDoItemForCell(_ index: Int) -> ToDo {
    let toDoItem = contextToDoList[index]
    return toDoItem
  }
  
  func checkmarkButtonPressedController(_ ID: String) -> String {
    toDoModelController = ToDoModelController()
    let checkmarkIcon = toDoModelController.checkmarkButtonPressedModel(ID)
    print(checkmarkIcon)
    if checkmarkIcon == true {
      print("asset \(checkMarkAsset.checkedCircle)")
      return checkMarkAsset.checkedCircle
    } else {
      print("asset \(checkMarkAsset.uncheckedCircle)")
      return checkMarkAsset.uncheckedCircle
    }
  }
  
  
  // MARK: - Setting data
  
  func toDoItemsInContext() {
    guard let context = title else {return}
    contextToDoList = toDoModelController.toDoList.filter({$0.context == context})
  }
  
  func startCodableTestContext() {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Array.self, from: memoryList) as [String]{
        listOfContext = contextList
      }
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
