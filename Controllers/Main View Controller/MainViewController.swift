//
//  MainViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateCollectionViewDelegate: class {
  func insertContext(at index: IndexPath)
  func deleteContext(at index: IndexPath)
  func updateContext()
  func insertSection(_ section: Int)
  func deleteSections(_ section: Int)
  func moveItem(fromIndex: IndexPath, toIndex: IndexPath)
  func addContext()
  func editToNormal(for indexPath: IndexPath)
  func addToNormal()
  func editContext(for indexPath: IndexPath)
  func returnContextDataToEditOrAdd(for indexPath: IndexPath)
  func returnContextDataToDelete(for indexPath: IndexPath)
}

class MainViewController {
  
  enum mainViewMode {
    case normal
    case editing
    case adding
  }
  
  var controllerMode = mainViewMode.normal
  var remindersController: RemindersController!
  
  var listOfContext = ["Inbox", "Home", "Work", "Personal"]
  var selectedContextIndex = 0
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  var editingContext: IndexPath?
  var newCalendarContext: String?
  weak var updateCollectionViewDelegate: UpdateCollectionViewDelegate?
  var previousEditedIndexPath: IndexPath?
  
  init(controller: RemindersController) {
    remindersController = controller
    remindersController.calandarCompleteDelegate = self
    setContextList()
  }
  
  
  func numberOfRows() -> Int {
    if controllerMode == .adding {
      return listOfContext.count + 3
    } else {
      return listOfContext.count + 2
    }
  }
  
  func returnNumberOfItemInContext(_ index: Int) -> Int {
    let context = listOfContext[index]
    let filteredToDoList = remindersController.incompleteReminderList.filter({$0.context == context})
    return filteredToDoList.count
  }
  
  func returnCellNumberOfContextString(_ index: Int) -> String {
    let context = listOfContext[index]
    let filteredToDoList = remindersController.incompleteReminderList.filter({$0.context == context})
    let uncheckedContext = filteredToDoList.filter({$0.isChecked == false})
    let uncheckedContextInt = uncheckedContext.count
    if uncheckedContextInt == 0 {
      return ""
    } else {
      return String(describing: uncheckedContextInt)
    }
  }
  
  func returnCellNumberOfToday() -> String {
    let filteredIncompleteReminders = remindersController.incompleteReminderList.filter({$0.dueDate != nil})
    let cal = Calendar(identifier: .gregorian)
    let newDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    let overDueItems = filteredIncompleteReminders.filter({$0.dueDate! < newDate})
    let todayItems = filteredIncompleteReminders.filter({ cal.isDateInToday($0.dueDate ?? Date()) })
    let count = overDueItems.count + todayItems.count
    if count == 0 {
      return ""
    } else {
      return String(count)
    }
  }
  
  func checkIfEditing() -> Bool {
    if editingContext != nil {
      return true
    } else {
      return false
    }
  }
  
  func setCalendarColor(color: UIColor, context: String) {
//    remindersController.createNewCalendar(context: context, color: color)
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
  
  func updateContextAndInsertNewContext() -> IndexPath {
    setContextList()
    if let newContext = newCalendarContext {
      newCalendarContext = nil
      guard let row = listOfContext.index(of: newContext) else {return IndexPath(row: listOfContext.count, section: 1)}
      print("3")
      let indexPath = IndexPath(row: row, section: 1)
      return indexPath
    } else {
      return IndexPath(row: listOfContext.count, section: 1)
    }
  }
  
  func setControllerModeToNormal() {
    switch controllerMode {
    case .adding:
      controllerMode = .normal
      updateCollectionViewDelegate?.addToNormal()
    case .editing:
      controllerMode = .normal
      guard let indexPath = previousEditedIndexPath else {return}
      previousEditedIndexPath = nil
      updateCollectionViewDelegate?.editToNormal(for: indexPath)
    case .normal:
      print("shouldnt be here")
    }
  }
  
  func saveButtonPressed() {
    switch controllerMode {
    case .adding:
      let indexPath = IndexPath(row: (listOfContext.count + 2), section: 0)
      updateCollectionViewDelegate?.returnContextDataToEditOrAdd(for: indexPath)
    case .editing:
      guard let indexPath = previousEditedIndexPath else {return}
      updateCollectionViewDelegate?.returnContextDataToEditOrAdd(for: indexPath)
    case .normal:
      print("normal")
    }
  }
  
  func createOrEditCalendar(context: String, color: UIColor) {
    switch controllerMode {
    case .adding:
      if context != "" {
        remindersController.createNewCalendar(context: context, color: color)
        setControllerModeToNormal()
        listOfContext.append(context)
        let indexPath = IndexPath(row: (listOfContext.count + 1), section: 0)
        updateCollectionViewDelegate?.insertContext(at: indexPath)
      }
    case .editing:
      if context != "" {
        guard let indexPath = previousEditedIndexPath else {return}
        remindersController.editCalendar(context: context, color: color, originalContext: listOfContext[indexPath.row - 2])
        setControllerModeToNormal()
        listOfContext[(indexPath.row - 2)] = context
      }
    case .normal:
      print("normal")
    }
  }
  
  func editingContext(for indexPath: IndexPath) {
    if indexPath.row == 0 || indexPath.row == 1 {
      return
    }
    if previousEditedIndexPath != indexPath {
      setControllerModeToNormal()
      previousEditedIndexPath = indexPath
      controllerMode = .editing
      updateCollectionViewDelegate?.editContext(for: indexPath)
    }
  }
  
  func addContextButtonPressed() {
    if controllerMode == .editing {
      guard let indexPath = previousEditedIndexPath else {return}
      previousEditedIndexPath = nil
      updateCollectionViewDelegate?.editToNormal(for: indexPath)
      controllerMode = .normal
    }
    if controllerMode != .adding {
      controllerMode = .adding
      updateCollectionViewDelegate?.addContext()
    }
  }
  
  func deleteButtonPressed() {
    print("delete button pressed at: \(controllerMode)")
    switch controllerMode {
    case .adding:
      setControllerModeToNormal()
    case .editing:
      guard let indexPath = previousEditedIndexPath else {return}
      updateCollectionViewDelegate?.returnContextDataToDelete(for: indexPath)
    case .normal:
      print("normal")
    }
  }
  
  func deleteCalendar(context: String) {
    print("deleting")
    remindersController.removeCalendar(context: context)
    guard let previousIndexPath = previousEditedIndexPath else {return}
    listOfContext.remove(at: previousIndexPath.row - 2)
    updateCollectionViewDelegate?.deleteContext(at: previousIndexPath)
    controllerMode = .normal
    previousEditedIndexPath = nil
  }
  
  func setContextList() {
    let contextList: [String] = remindersController.calendars.flatMap({$0.title})
    listOfContext = contextList.sorted(by: {$0 < $1})
  }
  
  func returnColor(_ index: String) -> UIColor {
    guard let calendar = remindersController.calendars.filter({$0.title == index}).first else {return contextColors[11]}
    guard let color = calendar.cgColor else {return contextColors[11]}
    let uiColor = UIColor.init(cgColor: color)
    return uiColor
  }
  
  func loadData() {
    remindersController.loadReminderData { [unowned self] (Reminders) in
      if !Reminders.isEmpty {
        self.updateCollectionViewDelegate?.updateContext()
      }
    }
  }
  
}

extension MainViewController: CalandarCompleteDelegate {
  func calendarNotificationUpdate() {
    setContextList()
    updateCollectionViewDelegate?.updateContext()
  }
}
