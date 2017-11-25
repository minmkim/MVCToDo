
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
  
  func makeNewNotification(title: String, date: Date, identifier: String) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.launchImageName = "AppIcon"
    content.sound = UNNotificationSound.default()
    content.categoryIdentifier = "UYLReminderCategory"
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    let identifier = identifier
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request, withCompletionHandler: { (error) in
      if error != nil {
        print(error ?? "Error")
      }
    })
  }
  
  func makeNewNagNotification(title: String, date: Date, identifier: String, nagFrequency: Int) {
    for i in 0...4 { // make 5 notifications
      let tempCalculatedDateString = calculateDateMinutesAndFormatDateToString(minutes: (i * nagFrequency), date: date, format: "MMM dd, yyyy hh:mm a")
      makeNewNotification(title: title, date: tempCalculatedDateString, identifier: ("\(i)\(identifier)"))
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
      let identifier = identifier
      for notification:UNNotificationRequest in notificationRequests {
        if notification.identifier == identifier {
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        }
      }
    }
  }
  
  func removeNagNotification(identifier: String) {
    for i in 0...4 {
      removeNotification(identifier: ("\(i)\(identifier)"))
    }
  }
  
  func calculateDateMinutesAndFormatDateToString(minutes: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .minute, value: minutes, to: date)
 //   let result = formatter.date(from: newDay!)
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

