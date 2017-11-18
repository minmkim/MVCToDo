
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
  
}
