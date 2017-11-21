//
//  CalendarNetworkController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit

class CalendarNetworkController {
  
  let eventStore = EKEventStore()
  var calendars = [EKCalendar]()
  var events: [EKEvent]?
  var allEvents = [EKEvent]()
  
  func requestAccessToCalendar() {
    eventStore.requestAccess(to: EKEntityType.event, completion: {
      (accessGranted: Bool, error: Error?) in
      
      if accessGranted == true {
        DispatchQueue.main.async(execute: {
          self.loadCalendars()
        })
      } else {
        DispatchQueue.main.async(execute: {
          print(error.debugDescription)
        })
      }
    })
  }
  
  func loadCalendars() {
    self.calendars = eventStore.calendars(for: EKEntityType.event)
  }
  
  func loadEvents(StartDate: String, EndDate: String) -> [EKEvent] {
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
       // print(events)
        if let tempEvent = events {
          for event in tempEvent {
           // print(event)
            allEvents.append(event)
          }
        }
      }
    }
    return allEvents
  }
  
}
