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
  func updateCell(originIndex: IndexPath, updatedReminder: Reminder)
}

class ContextItemController {
  
  var remindersController: RemindersController
  weak var delegate: UpdateContextItemTableViewDelegate?
  
  //drag and drop var
  var dragAndDropReminder: Reminder?
  var dragIndexPathOrigin: IndexPath?

  var title: String?
  
  init(remindersController: RemindersController, title: String) {
    self.remindersController = remindersController
    self.title = title
    startCodableTestContext()
    makeContextListFromColors()
    toDoItemsInContext()
    returnContextHeaders()
  }
 
  var listOfContextAndColors = ["None": 0, "Inbox": 2, "Home": 4, "Work": 6, "Personal": 8]
  var listOfContext = ["None", "Inbox", "Home", "Work", "Personal"]
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  
  var contextReminderList = [Reminder]()
  var listOfContextHeaders = [String]()
  var dictionaryOfContexts = [String:[Reminder]]()
  var reminder: Reminder?
  
  
  func returnContextHeaders() {
    listOfContextHeaders = contextReminderList.flatMap( {$0.contextParent} )
    listOfContextHeaders = Array(Set(listOfContextHeaders))
    if listOfContextHeaders.count == 0 {
      listOfContextHeaders.insert("", at: 0)
      print("listOfContextHeaders \(listOfContextHeaders)")
      print("contextReminderList \(contextReminderList)")
    }
    listOfContextHeaders = listOfContextHeaders.sorted(by: {$0 < $1})
    createContextListUnderHeader()
  }
  
  func createContextListUnderHeader() {
    for context in listOfContextHeaders {
      if context == "" {
        let listOfContextsWithHeader = contextReminderList.filter({$0.contextParent == nil})
        dictionaryOfContexts[context] = listOfContextsWithHeader
      } else {
        let listOfContextsWithHeader = contextReminderList.filter({$0.contextParent == context})
        dictionaryOfContexts[context] = listOfContextsWithHeader
      }
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
  
  func returnToDoItemForCell(_ index: IndexPath) -> Reminder {
    let context = listOfContextHeaders[index.section]
    let listOfRemindersInContext = dictionaryOfContexts[context]
    let reminder = listOfRemindersInContext![index.row] // remove this !
    return reminder
  }
  
  func returnNavigationBarColor() -> UIColor {
    guard let calendar = remindersController.calendars.filter({$0.title == title}).first else {return colors.gray}
    print("color here")
    return UIColor(cgColor: calendar.cgColor)
  }
  
  func setEditingToDo(_ reminder: Reminder) {
    self.reminder = reminder
  }
  
  func returnEditingToDo() -> Reminder? {
    return reminder
  }
  
//  func deleteItem(ID: String, index: IndexPath) {
//    guard let toDoIndex = contextToDoList.index(where: {$0.calendarRecordID == ID}) else {return}
//    contextToDoList.remove(at: toDoIndex)
//    toDoModelController.deleteToDoItem(ID: ID)
//    let parent = listOfContextHeaders[index.section]
//    let contextList = dictionaryOfContexts[parent]
//    guard let filteredContextList = contextList?.filter( {$0.calendarRecordID != ID}) else {return}
//    dictionaryOfContexts[parent] = filteredContextList
//    if filteredContextList.count == 0 {
//      dictionaryOfContexts[parent] = nil
//      listOfContextHeaders.remove(at: index.section)
//      delegate?.beginUpdate()
//      delegate?.deleteSection(index)
//      delegate?.deleteRow(index)
//      if listOfContextHeaders.count == 0 {
//        listOfContextHeaders.append("")
//        delegate?.insertSection(index)
//      }
//      delegate?.endUpdate()
//    } else {
//      delegate?.deleteRow(index)
//    }
//  }
  
  // MARK: - Setting data
  
  func toDoItemsInContext() {
    let uncheckedList = remindersController.incompleteReminderList
    guard let context = title else {return}
    contextReminderList = uncheckedList.filter({$0.context == context})
  }
  
  func makeContextListFromColors() {
    listOfContext = listOfContextAndColors.keys.map({$0})
  }
  
  // MARK: Drag and Drop functions
  
  func returnDragIndexPath(_ indexPath: IndexPath) {
    dragIndexPathOrigin = indexPath
  }
  
  func dragAndDropInitiated(_ reminder: Reminder) {
    dragAndDropReminder = reminder
  }
  
  func updateNewParentSectionWithDrop(_ destinationIndex: IndexPath) {
    guard let originReminder = dragAndDropReminder else {return}
    guard let originIndex = dragIndexPathOrigin else {return}
    let newParent = listOfContextHeaders[destinationIndex.section]
    var updatedReminder = originReminder
    updatedReminder.contextParent = newParent
//    toDoModelController.editToDoItem(updatedToDo)
    updateContextReminderListWithNewParent(reminder: originReminder, newParent: newParent)
    updateDictionaryContext(originReminderItem: originReminder, newParent: newParent, updatedReminder: updatedReminder)

    delegate?.beginUpdate()
    delegate?.updateCell(originIndex: originIndex, updatedReminder: updatedReminder)
    delegate?.moveRowAt(originIndex: originIndex, destinationIndex: destinationIndex)
    delegate?.endUpdate()
  }
  
  func updateContextReminderListWithNewParent(reminder: Reminder, newParent: String) {
    guard let index = contextReminderList.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
    contextReminderList[index].contextParent = newParent
  }
  
  func updateDictionaryContext(originReminderItem: Reminder, newParent: String, updatedReminder: Reminder) {
    guard var listOfReminderInContext = dictionaryOfContexts[originReminderItem.calendarRecordID] else {return}
    listOfReminderInContext = listOfReminderInContext.filter( {$0.calendarRecordID != originReminderItem.calendarRecordID})
    dictionaryOfContexts[originReminderItem.contextParent ?? ""] = listOfReminderInContext
    guard var newListOfReminderInContext = dictionaryOfContexts[newParent] else {return}
    newListOfReminderInContext.append(updatedReminder)
    dictionaryOfContexts[newParent] = newListOfReminderInContext
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
}
