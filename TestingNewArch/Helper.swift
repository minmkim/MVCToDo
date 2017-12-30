//
//  Helper.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class Helper {
  
  static func formatStringToDate(date: String, format: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    guard let result = formatter.date(from: date) else {
      return formatter.date(from: "Mar 14, 1984")!
    }
    return result
  }
  
  static func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
  }
  
  static func calculateDate(days: Int, date: Date, format: String) -> String {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay ?? Date())
    return result
  }
  
  static func calculateDateComponent(byAdding: Calendar.Component, numberOf: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: byAdding, value: numberOf, to: date)
    return newDay ?? Date()
  }
  
  static func calculateDateMinutesAndFormatDateToString(minutes: Int, date: Date, format: String) -> String{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .minute, value: minutes, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }
  
  static func calculateDateAndFormatDateToString(days: Int, date: Date, format: String) -> String{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }
  
  static func formatDateForAlarm(dueDate: String, dueTime: String) -> Date {
    let dateTime = ("\(dueDate) \(dueTime)")
    let formattedDateAndTime = Helper.formatStringToDate(date: dateTime, format: "YYYYMMdd hh:mm a")
    return formattedDateAndTime
  }
  
  static func calculateTimeBetweenDates(originalDate: Date?, finalDate: Date) -> Int {
    let calendar = Calendar.current
    guard let originalDate = originalDate else {return 100}
    let timeDifference = calendar.dateComponents([.second], from: originalDate, to: finalDate)
    guard let seconds = timeDifference.second else {return 1000}
    return seconds
  }
  
}
