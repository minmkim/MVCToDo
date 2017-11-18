//
//  CalendarModelController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit

class CalendarModelController {
  
  //adding calendar functionality
  
  let calendarNetworkController = CalendarNetworkController()
  
  let eventStore = EKEventStore()
  var calendars = [EKCalendar]()
  var events: [EKEvent]?
  
  func checkCalendarAuthorizationStatus() {
    let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
    switch (status) {
    case EKAuthorizationStatus.notDetermined:
      // This happens on first-run
      requestAccessToCalendar()
    case EKAuthorizationStatus.authorized:
      // Things are in line with being able to show the calendars in the table view
      loadCalendars()
      refreshTableView()
    case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
      // We need to help them give us permission
      // needPermissionView.fadeIn()
      break
    }
  }
  
  func requestAccessToCalendar() {
    eventStore.requestAccess(to: EKEntityType.event, completion: {
      (accessGranted: Bool, error: Error?) in
      
      if accessGranted == true {
        DispatchQueue.main.async(execute: {
          self.loadCalendars()
          self.refreshTableView()
        })
      } else {
        DispatchQueue.main.async(execute: {
          //  self.needPermissionView.fadeIn()
        })
      }
    })
  }
  
  func loadCalendars() {
    self.calendars = eventStore.calendars(for: EKEntityType.event)
    //   print(calendars)
  }
  
  func refreshTableView() {
    //   calendarsTableView.isHidden = false
    //   calendarsTableView.reloadData()
  }
  
  
  
  
  
  
  
  

  
  
  var calendar: EKCalendar? // Passed in from previous view controller
  
  var allEvents = [EKEvent]() // list of all events
  var sideEvents = [EKEvent]() // new list to renew
  
  func loadEvents(StartDate: String, EndDate: String) -> Bool {
    // Create a date formatter instance to use for converting a string to a date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // Create start and end date NSDate instances to build a predicate for which events to select
    let startDate = dateFormatter.date(from: StartDate)
    let endDate = dateFormatter.date(from: EndDate)
    for calendar in calendars {
      if let startDate = startDate, let endDate = endDate {
        let eventStore = EKEventStore()
        
        // Use an event store instance to create and properly configure an NSPredicate
        let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar])
        
        // Use the configured NSPredicate to find and return events in the store that match
        self.events = eventStore.events(matching: eventsPredicate).sorted(){
          (e1: EKEvent, e2: EKEvent) -> Bool in
          return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
        }
        if let tempEvent = events {
          for event in tempEvent {
            allEvents.append(event)
          }
        }
      }
    }
    print(events)
    return true
  }
  
  
}
