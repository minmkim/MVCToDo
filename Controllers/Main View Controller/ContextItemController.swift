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
  func updateTableView()
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
    remindersInContext()
    returnContextHeaders()
  }
  
  var contextReminderList = [Reminder]()
  var listOfContextHeaders = [String]()
  var dictionaryOfContexts = [String:[Reminder]]()
  var reminder: Reminder?
  
  func remindersInContext() {
    let uncheckedList = remindersController.incompleteReminderList
    guard let context = title else {return}
    contextReminderList = uncheckedList.filter({$0.context == context})
  }
  
  func returnContextHeaders() {
    listOfContextHeaders = contextReminderList.flatMap( {$0.contextParent} )
    listOfContextHeaders = Array(Set(listOfContextHeaders))
    if contextReminderList.contains(where: {$0.contextParent == nil}) {
      listOfContextHeaders.insert("", at: 0)
    }
    if listOfContextHeaders.count == 0 {
      listOfContextHeaders.insert("", at: 0)
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
    return UIColor(cgColor: calendar.cgColor)
  }
  
  func setEditingToDo(_ reminder: Reminder) {
    self.reminder = reminder
  }
  
  func returnEditingToDo() -> Reminder? {
    return reminder
  }
  
  func deleteItem(reminder: Reminder, index: IndexPath) {
    
    let parent = listOfContextHeaders[index.section]
    let contextList = dictionaryOfContexts[parent]
    guard let filteredContextList = contextList?.filter( {$0.calendarRecordID != reminder.calendarRecordID}) else {return}
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
    remindersController.removeReminder(reminder: reminder)
  }
  
  func checkmarkPressed(cellID: String) {
    if let reminder = remindersController.incompleteReminderList.filter({$0.calendarRecordID == cellID}).first {
      reminder.reminder.isCompleted = !reminder.reminder.isCompleted
      remindersController.editReminder(reminder: reminder.reminder)
      
      if let parent = reminder.contextParent {
        guard var list = dictionaryOfContexts[parent] else {return}
        guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        list[index] = Reminder(reminder.reminder)
        dictionaryOfContexts[parent] = list
      } else {
        guard var list = dictionaryOfContexts[""] else {return}
        guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        list[index] = Reminder(reminder.reminder)
        dictionaryOfContexts[""] = list
      }
    } else {
      guard let reminder = remindersController.completeReminderList.filter({$0.calendarRecordID == cellID}).first else {return}
      reminder.reminder.isCompleted = !reminder.reminder.isCompleted
      remindersController.editReminder(reminder: reminder.reminder)
      
      if let parent = reminder.contextParent {
        guard var list = dictionaryOfContexts[parent] else {return}
        guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        list[index] = Reminder(reminder.reminder)
        dictionaryOfContexts[parent] = list
      } else {
        guard var list = dictionaryOfContexts[""] else {return}
        guard let index = list.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
        list[index] = Reminder(reminder.reminder)
        dictionaryOfContexts[""] = list
      }
    }
    delegate?.updateTableView()
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
    if let newNote = updatedReminder.reminder.notes {
      if newNote.hasSuffix("}#@{!}") {
        let rangeOfZero = newNote.range(of: "{!}@#{", options: .backwards)
        // Get the characters after the last 0
        let suffix = String(describing: newNote.prefix(upTo: (rangeOfZero?.lowerBound)!))
        if suffix.hasSuffix("\n") {
          let newSuffix = String(suffix.dropLast())
          updatedReminder.reminder.notes = newSuffix
        } else {
          updatedReminder.reminder.notes = suffix
        }
      } else {
        updatedReminder.reminder.notes = newNote
      }
    }
    if newParent != "" {
      if updatedReminder.contextParent != nil {
        if var note = updatedReminder.reminder.notes {
          note.append("{!}@#{\(newParent)}#@{!}")
          updatedReminder.reminder.notes = note
        } else {
          let note = "{!}@#{\(newParent)}#@{!}"
          updatedReminder.reminder.notes = note
        }
      }
    }
    updateContextReminderListWithNewReminder(reminder: updatedReminder)
    updateDictionaryContext(originReminderItem: originReminder, newParent: newParent, updatedReminder: updatedReminder)
    remindersController.editReminder(reminder: updatedReminder.reminder)
    delegate?.beginUpdate()
    delegate?.updateCell(originIndex: originIndex, updatedReminder: updatedReminder)
    delegate?.moveRowAt(originIndex: originIndex, destinationIndex: destinationIndex)
    delegate?.endUpdate()
  }
  
  func updateContextReminderListWithNewReminder(reminder: Reminder) {
    guard let index = contextReminderList.index(where: {$0.calendarRecordID == reminder.calendarRecordID}) else {return}
    contextReminderList[index].reminder = reminder.reminder
  }
  
  func updateDictionaryContext(originReminderItem: Reminder, newParent: String, updatedReminder: Reminder) {
    guard var listOfReminderInContext = dictionaryOfContexts[originReminderItem.contextParent ?? ""] else {return}
    listOfReminderInContext = listOfReminderInContext.filter( {$0.calendarRecordID != originReminderItem.calendarRecordID})
    dictionaryOfContexts[originReminderItem.contextParent ?? ""] = listOfReminderInContext
    if dictionaryOfContexts[newParent] != nil {
      guard var newListOfReminderInContext = dictionaryOfContexts[newParent] else {return}
      newListOfReminderInContext.append(Reminder(updatedReminder.reminder))
      dictionaryOfContexts[newParent] = newListOfReminderInContext
    } else {
      dictionaryOfContexts[newParent] = [Reminder(updatedReminder.reminder)]
    }
  }
  
}

extension ContextItemController: SendDataToContextItemControllerDelegate {
  func addNewReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?) {
    print("add reminder delegate")
    var newReminder = remindersController.returnReminder()
    newReminder = remindersController.createReminder(reminder: newReminder, reminderTitle: reminderTitle, dueDate: dueDate, dueTime: dueTime, context: context, parent: parent, notes: notes, notification: isNotify, notifyDate: alarmTime, isRepeat: isRepeat, repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
    remindersController.setNewReminder(ekReminder: newReminder)
    delegate?.beginUpdate()
    if context == title {
      if let newParent = parent {
        if var parentList = dictionaryOfContexts[newParent] {
          parentList.append(Reminder(newReminder))
          dictionaryOfContexts[newParent] = parentList
          guard let index = listOfContextHeaders.index(where: {$0 == newParent}) else {return}
          let indexPath = IndexPath(row: (parentList.count - 1), section: index)
          delegate?.insertRow(indexPath)
        } else {
          dictionaryOfContexts[newParent] = [Reminder(newReminder)]
          listOfContextHeaders.append(newParent)
          let indexPath = IndexPath(row: 0, section: (listOfContextHeaders.count - 1))
          delegate?.insertSection(indexPath)
          delegate?.insertRow(indexPath)
        }
      } else {
        if var nilList = dictionaryOfContexts[""] {
          nilList.append(Reminder(newReminder))
          dictionaryOfContexts[""] = nilList
          let indexPath = IndexPath(row: (nilList.count - 1), section: 0)
          delegate?.insertRow(indexPath)
        } else {
          dictionaryOfContexts[""] = [Reminder(newReminder)]
          listOfContextHeaders.insert("", at: 0)
          let indexPath = IndexPath(row: 0, section: 0)
          delegate?.insertSection(indexPath)
          delegate?.insertRow(indexPath)
        }
      }
    }
    delegate?.endUpdate()
  }
  
  func editReminder(reminderTitle: String, context: String?, parent: String?, dueDate: Date?, dueTime: String?, notes: String?, isNotify: Bool, alarmTime: Date?, isRepeat: Bool, repeatCycleInterval: Int?, repeatCycle: Reminder.RepeatCycleValues?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?, endRepeatDate: Date?, oldReminder: Reminder) {
    guard let originalReminder = oldReminder.reminder else {return}
    var editedReminder = originalReminder
    editedReminder = remindersController.createReminder(reminder: originalReminder, reminderTitle: reminderTitle, dueDate: dueDate, dueTime: dueTime, context: context, parent: parent, notes: notes, notification: isNotify, notifyDate: alarmTime, isRepeat: isRepeat, repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeatDate: endRepeatDate)
    remindersController.editReminder(reminder: editedReminder)
    
    guard let oldReminder = reminder else {return}
    delegate?.beginUpdate()
    contextReminderList = contextReminderList.filter({$0.calendarRecordID != oldReminder.calendarRecordID})
    if let parent = oldReminder.contextParent {
      if var oldList = dictionaryOfContexts[parent] {
        guard let index = oldList.index(where: {$0.calendarRecordID == oldReminder.calendarRecordID}) else {return}
        oldList.remove(at: index)
        guard let section = listOfContextHeaders.index(where: {$0 == parent}) else {return}
        let indexPath = IndexPath(row: index, section: section)
        delegate?.deleteRow(indexPath)
        if oldList.count == 0 {
          listOfContextHeaders.remove(at: section)
          if listOfContextHeaders.count == 0 {
            listOfContextHeaders.append("")
            let newIndexPath = IndexPath(row: 0, section: 0)
            delegate?.insertSection(newIndexPath)
          }
          dictionaryOfContexts[parent] = nil
          delegate?.deleteSection(indexPath)
        } else {
          dictionaryOfContexts[parent] = oldList
        }
      }
    } else {
      if var oldList = dictionaryOfContexts[""] {
        guard let index = oldList.index(where: {$0.calendarRecordID == oldReminder.calendarRecordID}) else {return}
        oldList.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        if oldList.count == 0 {
          dictionaryOfContexts[""] = nil
          if listOfContextHeaders.count > 1 && listOfContextHeaders.contains("") {
            listOfContextHeaders.remove(at: 0)
          }
          delegate?.deleteSection(indexPath)
        } else {
          dictionaryOfContexts[""] = oldList
        }
        delegate?.deleteRow(indexPath)
      }
    }
    
    if context == title {
      contextReminderList.append(Reminder(editedReminder))
      if let newParent = parent {
        
        if var newList = dictionaryOfContexts[newParent] {
          newList.append(Reminder(editedReminder))
          dictionaryOfContexts[newParent] = newList
          let row = (newList.count - 1)
          guard let section = listOfContextHeaders.index(where: {$0 == newParent}) else {return}
          let indexPath = IndexPath(row: row, section: section)
          delegate?.insertRow(indexPath)
        } else {
          dictionaryOfContexts[newParent] = [Reminder(editedReminder)]
          listOfContextHeaders.append(newParent)
          let section = (listOfContextHeaders.count - 1)
          let indexPath = IndexPath(row: 0, section: section)
          delegate?.insertSection(indexPath)
          delegate?.insertRow(indexPath)
        }
      } else {
        
        if var nilContext = dictionaryOfContexts[""] {
          nilContext.append(Reminder(editedReminder))
          dictionaryOfContexts[""] = nilContext
          let row = (nilContext.count - 1)
          let indexPath = IndexPath(row: row, section: 0)
          delegate?.insertRow(indexPath)
        } else {
          dictionaryOfContexts[""] = [Reminder(editedReminder)]
          let indexPath = IndexPath(row: 0, section: 0)
          delegate?.insertSection(indexPath)
          delegate?.insertRow(indexPath)
        }
      }
    }
    delegate?.updateTableView()
    delegate?.endUpdate()
  }
  
}
