//
//  ContextController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/24/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

protocol ChosenContextDelegate: class {
  func sendChosenContext(_ context: String)
}

class ContextController {
  //listOfContext = listToUse
  var listOfContext = ["None", "Inbox", "Home", "Work", "Personal"]
  var filteredList: [String]?
  var chosenContext = ""
  var delegate: ChosenContextDelegate?
  
  init(){
    startCodableTestContext()
    filteredList = listOfContext
  }
  
  func returnCellLabel(_ index: Int) -> String {
    guard let cellLabel = filteredList?[index] else {return "Error"}
    return cellLabel
  }
  
  func removeContext(_ index: Int) {
    listOfContext.remove(at: index)
    filteredList!.remove(at: index)
  }
  
  func searchResults(_ searchText: String) {
    filteredList = listOfContext.filter { context in
      return context.lowercased().contains(searchText.lowercased())
    }
    filteredList! += ["Create: " + searchText]
  }
  
  func numberOfRowsInSection() -> Int {
    guard let numberOfRows = filteredList?.count else {return 0}
    return numberOfRows
  }
  
  func setChosenContext(_ context: String) {
    if context.hasPrefix("Create") {
      chosenContext = String(context.dropFirst(8)) //(Create: ) = 8 char
      listOfContext += ["\(chosenContext)"]
      saveContext()
    } else {
      chosenContext = context
    }
  }
  
  func sendContext() {
    print("sending \(chosenContext)")
    delegate?.sendChosenContext(chosenContext)
  }
  
  
  func saveContext() {
    //save it
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(listOfContext){
      UserDefaults.standard.set(encoded, forKey: "contextList")
    }
  }
  
  func startCodableTestContext() {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Array.self, from: memoryList) as [String]{
        listOfContext = contextList
      }
    }
  }
  

}
