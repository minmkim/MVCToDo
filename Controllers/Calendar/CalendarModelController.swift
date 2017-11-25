//
//  CalendarModelController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit
import UIKit


class CalendarModelController {
  
  //adding calendar functionality
  
  let calendarNetworkController = CalendarNetworkController()
  
  let eventStore = EKEventStore()
  var calendars = [EKCalendar]()
  var events = [EKEvent]() {
    didSet {
    }
  }
  var organizedCalendars = [CalendarEvent]()
  
  init() {
    checkCalendarAuthorizationStatus()
    self.calendars = calendarNetworkController.calendars
    let startDate = calculateDate(days: -100, date: Date(), format: "yyyy-MM-dd")
    let endDate = calculateDate(days: 400, date: Date(), format: "yyyy-MM-dd")
    requestCalendarInfo(StartDate: startDate, EndDate: endDate)
  }
  
  func checkCalendarAuthorizationStatus() {
    let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
    switch (status) {
    case EKAuthorizationStatus.notDetermined:
      // This happens on first-run
      calendarNetworkController.requestAccessToCalendar()
    case EKAuthorizationStatus.authorized:
      // Things are in line with being able to show the calendars in the table view
      calendarNetworkController.loadCalendars()
    // refreshTableView()
    case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
      // We need to help them give us permission
      //requestUserToGivePermission()
      break
    }
  }
  
  func requestUserToGivePermission() -> UIAlertController {
    let alertController = UIAlertController(title: "Sorry!", message: "Due Life does not have permission to your calendars. Please go to settings and give us permission!", preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
      print("OK")
    }
    alertController.addAction(okAction)
    //self.present(alertController, animated: true, completion: nil)
    return alertController
  }
  
  func requestCalendarInfo(StartDate: String, EndDate: String) {
    self.events = calendarNetworkController.loadEvents(StartDate: StartDate, EndDate: EndDate)
  }
  
  func organizeCalendarEvents() {
    for event in events {
      let newEvent = CalendarEvent(title: event.title, location: event.location, calendar: event.calendar.title, dueDate: event.startDate, end: event.endDate, allDay: event.isAllDay)
      organizedCalendars.append(newEvent)
    }
  }
  
  
  func calculateDate(days: Int, date: Date, format: String) -> String {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let newDay = calendar.date(byAdding: .day, value: days, to: date)
    let result = formatter.string(from: newDay!)
    return result
  }

}

