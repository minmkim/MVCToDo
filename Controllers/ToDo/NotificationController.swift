
//
//  File.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class NotificationController {
  
/*  func makeNewNotification(title: String, date: String, identifier: String) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.launchImageName = "AppIcon"
    content.sound = UNNotificationSound.default()
    content.categoryIdentifier = "UYLReminderCategory"
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
    let date = dateFormatter.date(from: date)
    let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date!)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    let identifier = identifier
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request, withCompletionHandler: { (error) in
      if error != nil {
        print(error ?? "Error")
      }
    })
  }
  
  func removeNotificationAfterEditing(identifier: String) {
    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
      let identifier = identifier
      for notification:UNNotificationRequest in notificationRequests {
        if notification.identifier == identifier {
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        }
      }
    }
  } */
  
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
  
}
