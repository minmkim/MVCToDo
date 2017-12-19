//
//  ContextController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/24/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

protocol ChosenParentDelegate: class {
  func returnChosenParent(_ parent: String)
}

class ParentController {
  
  var filteredList: [String]?
  var listOfParents = [String]()
  weak var delegate: ChosenParentDelegate?
  var chosenParent = ""
  
  init(context: String) {
//    let listOfToDoInContext = toDoModelController.toDoList.filter({$0.context == context})
//    listOfParents = listOfToDoInContext.map({$0.contextParent})
//    listOfParents = listOfParents.filter({$0 != ""})
//    listOfParents = Array(Set(listOfParents))
//    listOfParents = listOfParents.sorted(by: {$0 < $1} )
//    filteredList = listOfParents
  }
  
  func returnCellLabel(_ index: Int) -> String {
    guard let cellLabel = filteredList?[index] else {return "Error"}
    return cellLabel
  }
  
  func searchResults(_ searchText: String) {
    filteredList = listOfParents.filter { context in
      return context.lowercased().contains(searchText.lowercased())
    }
    filteredList! += ["Create: " + searchText]
  }
  
  func numberOfRowsInSection() -> Int {
    guard let numberOfRows = filteredList?.count else {return 0}
    return numberOfRows
  }
  
  func setChosenParent(_ parent: String) {
    if parent.hasPrefix("Create: ") {
      chosenParent = String(parent.dropFirst(8)) //(Create: ) = 8 char
    } else {
      chosenParent = parent
    }
  }
  
  func sendChosenParent() {
    delegate?.returnChosenParent(chosenParent)
  }
  
}

