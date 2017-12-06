//
//  ContextItemController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/27/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateContextItemTableViewDelegate: class {
  func deleteRow(_ indexPath: IndexPath)
  func deleteSection(_ indexPath: IndexPath)
  func insertSection(_ indexPath: IndexPath)
  func moveRowAt(originIndex: IndexPath, destinationIndex: IndexPath)
  func insertRow(_ indexPath: IndexPath)
  func beginUpdate()
  func endUpdate()
  func updateCell(originIndex: IndexPath, updatedToDo: ToDo)
}

class ContextItemController {
  
  var toDoModelController = ToDoModelController()
  var themeController = ThemeController()
  var delegate: UpdateContextItemTableViewDelegate?
  
  //drag and drop var
  var dragAndDropToDo: ToDo?
  var dragIndexPathOrigin: IndexPath?

  var title: String? {
    didSet {
      startCodableTestContext()
      makeContextListFromColors()
      toDoItemsInContext()
      returnContextHeaders()
    }
  }
 
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  var listOfContext = ["None", "Inbox", "Home", "Work", "Personal"]
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  
  var contextToDoList = [ToDo]()
  var listOfContextHeaders = [String]()
  var dictionaryOfContexts = [String:[ToDo]]()
  var toDoItem: ToDo?
  
  
  func returnContextHeaders() {
    listOfContextHeaders = contextToDoList.flatMap( {$0.contextSection} )
    listOfContextHeaders = Array(Set(listOfContextHeaders))
    if listOfContextHeaders.count == 0 {
      listOfContextHeaders.insert("", at: 0)
    }
    listOfContextHeaders = listOfContextHeaders.sorted(by: {$0 < $1})
    createContextListUnderHeader()
  }
  
  func createContextListUnderHeader() {
    for context in listOfContextHeaders {
      let listOfContextsWithHeader = contextToDoList.filter({$0.contextSection == context})
      dictionaryOfContexts[context] = listOfContextsWithHeader
    }
  }
  
  func returnContextHeaderHeight(_ section: Int) -> CGFloat {
    if listOfContextHeaders[section] == "" {
      return 30.0
    } else {
      return 48.0
    }
  }
  
  func returnContextHeader(_ index: Int) -> String {
    return listOfContextHeaders[index]
  }
  
  
  // MARK: - tableView data
  func returnNumberOfRowsInSection(_ index: Int) -> Int {
    let context = listOfContextHeaders[index]
    let numberOfRowsInContext = dictionaryOfContexts[context]?.count ?? 0
    return numberOfRowsInContext
  }
  
  func returnNumberOfSections() -> Int {
    let number = listOfContextHeaders.count
    if number != 0 {
      return number
    } else {
      return 1
    }
  }
  
  func returnToDoItemForCell(_ index: IndexPath) -> ToDo {
    let context = listOfContextHeaders[index.section]
    let listOfToDoInContext = dictionaryOfContexts[context]
    let toDo = listOfToDoInContext![index.row] // remove this !
    return toDo
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
  
  func deleteItem(ID: String, index: IndexPath) {
    guard let toDoIndex = contextToDoList.index(where: {$0.cloudRecordID == ID}) else {return}
    contextToDoList.remove(at: toDoIndex)
    toDoModelController.deleteToDoItem(ID: ID)
    let parent = listOfContextHeaders[index.section]
    let contextList = dictionaryOfContexts[parent]
    guard let filteredContextList = contextList?.filter( {$0.cloudRecordID != ID}) else {return}
    dictionaryOfContexts[parent] = filteredContextList
    if filteredContextList.count == 0 {
      dictionaryOfContexts[parent] = nil
      listOfContextHeaders.remove(at: index.section)
      delegate?.beginUpdate()
      delegate?.deleteSection(index)
      delegate?.deleteRow(index)
      if listOfContextHeaders.count == 0 {
        listOfContextHeaders.append("")
        delegate?.insertSection(index)
      }
      delegate?.endUpdate()
    } else {
      delegate?.deleteRow(index)
    }
  }
  
  // MARK: - Setting data
  
  func toDoItemsInContext() {
    toDoModelController = ToDoModelController()
    let uncheckedList = toDoModelController.toDoList.filter({$0.checked == false})
    guard let context = title else {return}
    contextToDoList = uncheckedList.filter({$0.context == context})
  }
  
  func makeContextListFromColors() {
    listOfContext = listOfContextAndColors.keys.map({$0})
  }
  
  // MARK: Drag and Drop functions
  
  func returnDragIndexPath(_ indexPath: IndexPath) {
    dragIndexPathOrigin = indexPath
  }
  
  func dragAndDropInitiated(_ ToDo: ToDo) {
    dragAndDropToDo = ToDo
  }
  
  func updateNewParentSectionWithDrop(_ destinationIndex: IndexPath) {
    guard let originToDoItem = dragAndDropToDo else {return}
    guard let originIndex = dragIndexPathOrigin else {return}
    let newParent = listOfContextHeaders[destinationIndex.section]
    var updatedToDo = originToDoItem
    updatedToDo.contextSection = newParent
    toDoModelController.editToDoItem(updatedToDo)
    updateContextToDoListWithNewParent(toDoItem: originToDoItem, newParent: newParent)
    updateDictionaryContext(originToDoItem: originToDoItem, newParent: newParent, updatedToDo: updatedToDo)

    delegate?.beginUpdate()
    delegate?.updateCell(originIndex: originIndex, updatedToDo: updatedToDo)
    delegate?.moveRowAt(originIndex: originIndex, destinationIndex: destinationIndex)
    delegate?.endUpdate()
  }
  
  func updateContextToDoListWithNewParent(toDoItem: ToDo, newParent: String) {
    guard let index = contextToDoList.index(where: {$0.cloudRecordID == toDoItem.cloudRecordID}) else {return}
    contextToDoList[index].contextSection = newParent
  }
  
  func updateDictionaryContext(originToDoItem: ToDo, newParent: String, updatedToDo: ToDo) {
    guard var listOfToDoInContext = dictionaryOfContexts[originToDoItem.contextSection] else {return}
    listOfToDoInContext = listOfToDoInContext.filter( {$0.cloudRecordID != originToDoItem.cloudRecordID})
    dictionaryOfContexts[originToDoItem.contextSection] = listOfToDoInContext
    guard var newListOfToDoInContext = dictionaryOfContexts[newParent] else {return}
    newListOfToDoInContext.append(updatedToDo)
    dictionaryOfContexts[newParent] = newListOfToDoInContext
    }
  
  func startCodableTestContext() {
    if let memoryList = UserDefaults.standard.value(forKey: "contextList") as? Data{
      let decoder = JSONDecoder()
      if let contextList = try? decoder.decode(Dictionary.self, from: memoryList) as [String: Int]{
        listOfContextAndColors = contextList
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
