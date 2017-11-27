//
//  MainViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class MainViewController {
  
  var toDoModelController = ToDoModelController()
  var listOfContext = [String]()
  var selectedContextIndex = 0
  
  init(){
    setContextList()
    listOfContext = listOfContext.filter( {$0 != "None"} )
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
    let numberOfContextInt = returnNumberOfItemInContext(index)
    if numberOfContextInt == 0 {
      return ""
    } else {
      return String(describing: numberOfContextInt)
    }
  }
  
  func setIndexPathForContextSelect(_ index: Int) {
    selectedContextIndex = index
  }
  
  func returnContextString(_ index: Int) -> String {
    return listOfContext[index]
  }
  
  func setContextList() {
    var toDoList = toDoModelController.toDoList.flatMap({$0.context})
    let restoreList = startCodableTestContext()
    toDoList += restoreList
    listOfContext = Array(Set(toDoList))
  }
  
  func saveContext() {
    //save it
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(listOfContext){
      UserDefaults.standard.set(encoded, forKey: "contextList")
    }
  }
  
  func startCodableTestContext() -> [String] {
    var listOfContexts = [String]()
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Array.self, from: memoryList) as [String]{
        listOfContexts = contextList
      }
    }
    return listOfContexts
  }
}
