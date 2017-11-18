//
//  AddToDoController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class AddEditToDoController {
  
  let toDoModelController = ToDoModelController()
  
  var toDoItem: ToDo?
  
  let calendar = Calendar.current
  var itemToEdit: ToDo? // item tht is being edited
  var firstItem: ToDo? // item when first appear on view
  var selectedDate: String = ""
  var selectedTime: String = ""
  var nagListOfContext = ["Minutes"]
  var listOfContext = ["None", "Inbox", "Home", "Work", "Personal"]
  var repeatingNotifications = ["Days", "Weeks", "Months"]
  var numberRepeat = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
  var numberArray = Array(1...60)
  var currentDate = "" // todayHeader
  var itemCount = 0
  var noteText = ""
  var repeatPickerView = UIPickerView()
  var cycleRepeatString: String?
  var numberRepeatInt: Int?
  var nagString = "Minutes"
  var nagInt: Int?
  
  var title: String?
  
  func updateLabels() -> [String] {
    if let editItem = toDoItem {
    var labelStrings = [String]()
    let toDoItem = editItem.toDoItem
    let context = editItem.context ?? ""
    let notes = editItem.notes ?? ""
    let dueDate = editItem.dueDate ?? ""
    let dueTime = editItem.dueTime ?? ""
    let repeatNumber = editItem.repeatNumber ?? 0
    let repeatCycle = editItem.repeatCycle ?? ""
    let nagNumber = editItem.nagNumber ?? 0
    labelStrings.append(toDoItem)
    labelStrings.append(context)
    labelStrings.append(dueDate)
    labelStrings.append(dueTime)
    labelStrings.append(notes)
    labelStrings.append(String(describing: repeatNumber))
    labelStrings.append(repeatCycle)
    labelStrings.append(String(describing: nagNumber))
    return labelStrings //[todoitem, context, duedate, duetime, notes, repeatnumber, repeatcycle, nagnumber]
    } else {
      return []
    }
  }
  
 /* func setTheme() {
    let appTheme = UserDefaults.standard.bool(forKey: "appTheme")
    if appTheme {
      self.view.backgroundColor = .black
      let cell = self.tableView.visibleCells
      for cell in cell {
        cell.backgroundColor = .black
      }
      contextLabel.textColor = .white
      dueDateLabel.textColor = .white
      dueTimeLabel.textColor = .white
      repeatLabel.textColor = .white
      nagText.textColor = .white
      
      toDoItemText.textColor = .white
      contextField.textColor = .white
      dueTimeField.textColor = .white
      repeatingField.textColor = .white
      nagLabel.textColor = .white
      
      dueDatePicker.setValue(UIColor.white, forKey: "textColor")
      dueTimePicker.setValue(UIColor.white, forKey: "textColor")
      repeatPicker.setValue(UIColor.white, forKey: "textColor")
    } else {
      self.view.backgroundColor = .white
      let cell = self.tableView.visibleCells
      for cell in cell {
        cell.backgroundColor = .white
      }
      contextLabel.textColor = .black
      dueDateLabel.textColor = .black
      dueTimeLabel.textColor = .black
      repeatLabel.textColor = .black
      nagText.textColor = .black
      
      toDoItemText.textColor = .black
      contextField.textColor = .black
      dueTimeField.textColor = .black
      repeatingField.textColor = .black
      nagLabel.textColor = .black
      
      dueDatePicker.setValue(UIColor.black, forKey: "textColor")
      dueTimePicker.setValue(UIColor.black, forKey: "textColor")
      repeatPicker.setValue(UIColor.black, forKey: "textColor")
    }
  }*/
  
  func setTitle() -> String {
    guard let titleString = title else {return "Error"}
    return titleString
  }
  
  
  func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.date(from: date)
    return result!
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let result = formatter.string(from: date)
    return result
  }
  
  func calculateDateMinutesAndFormatDateToString(minutes: Int, date: Date, format: String) -> String{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .minute, value: minutes, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }
  
  func calculateDateAndFormatDateToString(days: Int, date: Date, format: String) -> String{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }
  
 /* func done() {
    if UserDefaults.standard.bool(forKey: "purchased") == true || itemCount < 11 { // check for IAP
      let item = toDo(toDoItem: toDoItemText.text!, dueDate: dueDateField.text, dueTime: dueTimeField.text, checked: false, context: contextField.text, notes: noteText, repeatNumber: numberRepeatInt, repeatCycle: cycleRepeatString, nagNumber: nagInt, cloudRecordID: "")
      
      if self.dueDateField.text! != "" && self.dueTimeField.text! != "" {
        if item.nagNumber != nil { // if nag
          for i in 0...4 { // make 5 notifications
            let tempDate = formatStringToDate(date: ("\(self.dueDateField.text!) \(self.dueTimeField.text!)"), format: "MMM dd, yyyy hh:mm a")
            let tempCalculatedDateString = calculateDateMinutesAndFormatDateToString(minutes: (i * nagInt!), date: tempDate, format: "MMM dd, yyyy hh:mm a")
            makeNewNotification(title: self.toDoItemText.text!, date: tempCalculatedDateString, identifier: ("\(i)\(self.toDoItemText.text!) \(self.dueDateField.text!)"))
          }
        } else { //if no nag
          makeNewNotification(title: self.toDoItemText.text!, date: ("\(self.dueDateField.text!) \(self.dueTimeField.text!)"), identifier: ("\(self.toDoItemText.text!) \(self.dueDateField.text!)"))
        }
      }
      
      if self.firstItem?.toDoItem == nil {
        self.delegate?.addItemViewController(self, didFinishAdding: item)
      } else { //edit
        if firstItem?.dueTime != "" && dueDateField.text != firstItem?.dueDate {
          if firstItem?.nagNumber != nil {
            for i in 0...4 {
              removeNotificationAfterEditing(identifier: ("\(i)\(String(describing: self.firstItem?.toDoItem)) \(String(describing: self.firstItem?.dueDate))"))
            }
          } else {
            removeNotificationAfterEditing(identifier: ("\(String(describing: self.firstItem?.toDoItem)) \(String(describing: self.firstItem?.dueDate))"))
          }
        }
        self.delegate?.addItemViewController(self, didFinishEditingItem: item)
      }
      
      saveContext()
      
    } else { // if user has over 10 items in todo and has not purchased IAP
      let alertController = UIAlertController(title: "Sorry", message: "You have reached the limit of 10 Items. Please make the in app purchase of $1.99 to unlock the restriction!", preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        print("OK")
      }
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }*/
  
  
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // update list if coming from edit segue
 /* func updateList() {
    if let toDoItem = itemToEdit?.toDoItem {
      title = "Edit Item"
      firstItem = itemToEdit
      toDoItemText.text = toDoItem
      contextField.text = itemToEdit?.context
      noteText = itemToEdit?.notes ?? ""
      selectedDate = itemToEdit?.dueDate ?? ""
      dueDateField.text = selectedDate
      dueTimeField.text = itemToEdit?.dueTime
      numberRepeatInt = itemToEdit?.repeatNumber ?? nil
      cycleRepeatString = itemToEdit?.repeatCycle ?? ""
      if numberRepeatInt == nil {
        
      } else if numberRepeatInt == 1 {
        switch cycleRepeatString {
        case "Days"?:
          repeatingField.text = "Every Day"
        case "Weeks"?:
          repeatingField.text = "Every Week"
        case "Months"?:
          repeatingField.text = "Every Month"
        default:
          print("error in selecting picker row")
        }
      } else {
        repeatingField.text = "Every \(itemToEdit?.repeatNumber!) \(itemToEdit?.repeatCycle!)"
      }
      nagInt = itemToEdit?.nagNumber
      if nagInt == nil {
      } else if nagInt == 1 {
        nagLabel.text = "Every Minute"
      } else {
        nagLabel.text = "Every \(nagInt!) Minutes"
      }
    }
  }*/
  
}
