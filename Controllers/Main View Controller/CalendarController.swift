//
//  CalendarViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation


class CalendarController {
  
  let eventController = EventController()
  let ModelController = ToDoModelController()
  
  func eventsDate(_ indexPath: IndexPath) {
    let indexPathSection = indexPath.section
    let numberOfDays = indexPathSection - 100
    let date = calculateDate(days: numberOfDays, date: Date(), format: dateAndTime.monthDateYear)
    let dateEvents = ModelController.toDoList.filter( {$0.dueDate == date})
    

    let numberOfEvents = dateEvents.count // this will give number of events today - need to check for unchecked to add to label
  }
  
  
  
  
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
  
  func calendarPress(indexPathRow: Int) -> String {
    let numberOfDaysFromToday = indexPathRow - 100
    let pressedDate = calculateDate(days: numberOfDaysFromToday, date: Date(), format: dateAndTime.monthDateYear)
    let formattedPressedDateString = formatDateToString(date: pressedDate, format: dateAndTime.monthDateYear)
    return formattedPressedDateString
  }
  
  func formatDateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = format
    let result = formatter.string(from: date)
    return result
  }
  
  
  func calculateDate(days: Int, date: Date, format: String) -> Date {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    guard let newDay = calendar.date(byAdding: .day, value: days, to: date) else {return Date()}
    return newDay
  }
  
}
