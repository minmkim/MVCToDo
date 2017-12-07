
//
//  File.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController {
  
  let center = UNUserNotificationCenter.current()
  let completeAction = UNNotificationAction(identifier: "Complete", title: "Complete", options: [])
  let ignoreAction = UNNotificationAction(identifier: "Ignore", title: "Ignore", options: [])
  let postponeHourAction = UNNotificationAction(identifier: "Postpone One Hour", title: "Postpone One Hour", options: [])
  let postponeDayAction = UNNotificationAction(identifier: "Postpone One Day", title: "Postpone One Day", options: [])
  
  func makeNewNotification(title: String, date: Date, identifier: String) {
    var ID = ""
    if identifier.count != 36 {
      ID = ("\(identifier)0")
    } else {
      ID = identifier
    }
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.launchImageName = "AppIcon"
    content.sound = UNNotificationSound.default()
    let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                          actions: [completeAction,postponeHourAction, postponeDayAction, ignoreAction],
                                          intentIdentifiers: [], options: [])
    center.setNotificationCategories([category])
    content.categoryIdentifier = "UYLReminderCategory"
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    let notificationIdentifier = ID
    let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
    center.add(request, withCompletionHandler: { (error) in
      if error != nil {
        print(error ?? "Error")
      }
    })
  }
  
  func makeNewNagNotification(title: String, date: Date, identifier: String, nagFrequency: Int) {
    for i in 0...4 { // make 5 notifications
      let tempCalculatedDateString = calculateDateMinutesAndFormatDateToString(minutes: (i * nagFrequency), date: date, format: "MMM dd, yyyy hh:mm a")
      makeNewNotification(title: title, date: tempCalculatedDateString, identifier: ("\(identifier)\(i)"))
    }
  }
  
  func formatDateAndTime(dueDate: Date, dueTime: String) -> Date {
    let formattedDate: String = formatDateToString(date: dueDate, format: dateAndTime.monthDateYear)
    let dateTime = ("\(formattedDate) \(dueTime)")
    let formattedDateAndTime = formatStringToDate(date: dateTime, format: "MMM dd, yyyy hh:mm a")
    return formattedDateAndTime
  }
  
  func removeNotification(identifier: String) {
    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
      var ID = ""
      if identifier.count != 36 {
        ID = ("\(identifier)0")
      } else {
        ID = identifier
      }
      
      for notification:UNNotificationRequest in notificationRequests {
        if notification.identifier == ID { UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        }
      }
    }
  }
  
  
  
  func removeNagNotification(identifier: String) {
    for i in 0...4 {
      removeNotification(identifier: ("\(identifier)\(i)"))
    }
  }
  
  func calculateDateMinutesAndFormatDateToString(minutes: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .minute, value: minutes, to: date)
    return newDay ?? Date()
  }
  
  func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    guard let result = formatter.date(from: date) else {
      return formatter.date(from: "Mar 14, 1984")!
    }
    return result
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
  }
  
}

