//
//  CalendarViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class CalendarController {
  
  func calculateDayNumberForCell(indexPathRow: Int) -> String {
    let index = indexPathRow - 100 //start calendar 100 days prior
    let calendar = Calendar.current
    let dayNumber: Int?
    let calculatedDate = calendar.date(byAdding: .day, value: index, to: Date())
    dayNumber = calendar.component(.day, from: calculatedDate ?? Date())
    let dayNumberString = String(describing: dayNumber ?? 0)
    return dayNumberString
  }
  
  func calculateDayOfWeekLabelForCell(indexPathRow: Int) -> String {
    let index = indexPathRow - 100 //start calendar 100 days prior
    let formatter = DateFormatter()
    var dayOfWeek: String?
    let calendar = Calendar.current
    let calculatedDate = calendar.date(byAdding: .day, value: index, to: Date())
    formatter.dateFormat = "EEE"
    dayOfWeek = formatter.string(from: calculatedDate ?? Date())
    dayOfWeek = dayOfWeek?.uppercased()
    guard let dayOfWeekString = dayOfWeek else {return ""}
    return dayOfWeekString
  }
  
  func convertIndexPathRowToDateString(_ indexPathRow: Int) -> String {
    let numberOfDaysFromToday = indexPathRow - 100
    let pressedDate = calculateDate(days: numberOfDaysFromToday, date: Date(), format: dateAndTime.yearMonthDay)
    let formattedPressedDateString = Helper.formatDateToString(date: pressedDate, format: dateAndTime.yearMonthDay)
    return formattedPressedDateString
  }
  
  func calculateDayOfMonthFromIndexRow(_ indexRow: Int) -> String {
    let index = indexRow - 100 //start calendar 100 days prior
    let formatter = DateFormatter()
    var dayOfWeek: String?
    let calendar = Calendar.current
    let calculatedDate = calendar.date(byAdding: .day, value: index, to: Date())
    formatter.dateFormat = "MMMM"
    dayOfWeek = formatter.string(from: calculatedDate ?? Date())
    guard let dayOfWeekString = dayOfWeek else {return ""}
    return dayOfWeekString
  }
  
  func updateMonthLabel(IndexArray: [IndexPath]) -> String {
    let sortedArray = IndexArray.sorted(by: {$0[1] < $1[1]})
    if sortedArray != [] {
      let firstCellIndexRow = (sortedArray[0][1] + 1)
      let monthString = calculateDayOfMonthFromIndexRow(firstCellIndexRow)
      return monthString
    } else {
      return ""
    }
  }
  // MARK: Date Formatting functions
  
  func calculateDate(days: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    guard let newDay = calendar.date(byAdding: .day, value: days, to: date) else {return Date()}
    return newDay
  }
  
}
