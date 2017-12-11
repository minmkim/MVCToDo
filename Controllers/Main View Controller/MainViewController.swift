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
  
  var toDoModelController = ToDoModelController()
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  var listOfContext = ["Inbox", "Home", "Work", "Personal"]
  var selectedContextIndex = 0
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  var editingContext: IndexPath?
  
  init(){
    setContextList()
  }
  
  func numberOfContext() -> Int {
    return listOfContext.count
  }
  
  func returnNumberOfItemInContext(_ index: Int) -> Int {
    let context = listOfContext[index]
    let filteredToDoList = toDoModelController.toDoList.filter({$0.context == context})
    return filteredToDoList.count
  }
  
  func returnCellNumberOfContextString(_ index: Int) -> String {
    let context = listOfContext[index]
    let filteredToDoList = toDoModelController.toDoList.filter({$0.context == context})
    let uncheckedContext = filteredToDoList.filter({$0.checked == false})
    let uncheckedContextInt = uncheckedContext.count
    if uncheckedContextInt == 0 {
      return ""
    } else {
      return String(describing: uncheckedContextInt)
    }
  }
  
  func returnCellNumberOfToday() -> String {
    let uncheckedListOfToDo = toDoModelController.toDoList.filter({$0.checked == false})
    let filteredUncheckedListOfToDo = uncheckedListOfToDo.filter({$0.dueDate != nil})
    let date: Date = Date()
    let cal: Calendar = Calendar(identifier: .gregorian)
    
    let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
    let overDueItems = filteredUncheckedListOfToDo.filter({$0.dueDate! < newDate})
    let todayItems = uncheckedListOfToDo.filter({
      formatDateToString(date: $0.dueDate ?? Date(), format: dateAndTime.monthDateYear) == formatDateToString(date: Date(), format: dateAndTime.monthDateYear)
    })
    let count = todayItems.count + overDueItems.count
    return String(count)
  }
  
  func checkIfEditing() -> Bool {
    if editingContext != nil {
      return true
    } else {
      return false
    }
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
  
  func addContextSavedPressed(color: UIColor, context: String) {
    let indexOfColor = contextColors.index(of: color)
    listOfContextAndColors[context] = indexOfColor
    saveContext()
  }
  
  func returnNewIndexPath(_ context: String) -> IndexPath {
    setContextList()
    let row = listOfContext.index(of: context)
    let indexPath = IndexPath(row: row!, section: 1)
    return indexPath
  }
  
  
  func setContextList() {
    var toDoList = toDoModelController.toDoList.flatMap({$0.context})
    let restoreList = startCodableTestContext()
    let stringRestoreList = makeContextListFromColors(restoreList)
    toDoList += stringRestoreList
    listOfContext = Array(Set(toDoList))
    listOfContext = listOfContext.sorted(by: {$0 < $1})
    listOfContext = listOfContext.filter( {$0 != "None"} )
    listOfContext = listOfContext.filter( {$0 != "Today"} )
    listOfContext = listOfContext.filter( {$0 != ""} )
  }
  
  func saveContext() {
    //save it
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(listOfContextAndColors){
      UserDefaults.standard.set(encoded, forKey: "contextList")
    }
  }
  
  func returnColor(_ index: String) -> UIColor {
    guard let colorInt = listOfContextAndColors[index] else {return colors.gray}
    let color = contextColors[colorInt]
    return color
  }
  
  func makeContextListFromColors(_ list: [String:Int]) -> [String] {
    let newList = list.keys.map({$0})
    return newList
  }
  
  func startCodableTestContext() -> [String:Int] {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Dictionary.self, from: memoryList) as [String:Int]{
        listOfContextAndColors = contextList
      }
    }
    return listOfContextAndColors
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
  }
  
}
