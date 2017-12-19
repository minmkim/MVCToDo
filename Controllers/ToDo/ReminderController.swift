//
//  ReminderController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit

class Remindercontroller {
  
  let eventStore = EKEventStore()
  var calendarReminderdictionary = [EKCalendar:[EKReminder]]()
  var calendars = [EKCalendar]()
  var reminders = [EKReminder]()
  var incompleteReminders = [EKReminder]()
  weak var delegate: RemindersUpdatedDelegate?
  
//  init() {
//    NotificationCenter.default.addObserver(self, selector: #selector(storeChanged), name: .EKEventStoreChanged, object: eventStore)
//    calendars = eventStore.calendars(for: EKEntityType.reminder)
//  }
//  
//  deinit {
//    print("deinit ReminderController")
//    NotificationCenter.default.removeObserver(storeChanged)
//  }
  
  @objc func storeChanged(_ notification: Notification) {
    calendars = eventStore.calendars(for: EKEntityType.reminder)
    delegate?.updateData()
  }
  
  func loadIncompleteReminders(completionHandler: @escaping ([EKCalendar:[EKReminder]]) -> ()) {
    let incompletePredicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
    eventStore.fetchReminders(matching: incompletePredicate, completion: { (reminders: [EKReminder]?) -> Void in
      self.incompleteReminders = reminders!
      for calendar in self.calendars {
        let calendarList = self.incompleteReminders.filter({$0.calendar == calendar})
        self.calendarReminderdictionary[calendar] = calendarList
      }
      completionHandler(self.calendarReminderdictionary)
    })
  }
  
  func loadCompletedReminderData(completionHandler: @escaping () -> ()) {
    calendars =
      eventStore.calendars(for: EKEntityType.reminder)
    let completePredicate = eventStore.predicateForCompletedReminders(withCompletionDateStarting: nil, ending: nil, calendars: nil)
    
    DispatchQueue.global().async {
      self.eventStore.fetchReminders(matching: completePredicate, completion: { (reminders: [EKReminder]?) -> Void in
        self.reminders = reminders!
        completionHandler()
      })
    }
  }
  
  func formatDateForAlarm(dueDate: String, dueTime: String) -> Date {
    let dateTime = ("\(dueDate) \(dueTime)")
    let formattedDateAndTime = Helper.formatStringToDate(date: dateTime, format: "YYYYMMdd hh:mm a")
    return formattedDateAndTime
  }
  
  func returnReminder(reminder: EKReminder, toDoItem: ToDo) -> EKReminder {
    
    reminder.title = toDoItem.toDoItem
    reminder.isCompleted = false
    reminder.notes = toDoItem.notes
    
    var dateComponents: DateComponents? = nil
    if toDoItem.dueDate != nil {
      if toDoItem.dueTime == "" || toDoItem.dueTime == nil {
        dateComponents = setDateComponentsForDueDateNoTime(for: toDoItem.dueDate!)
      } else {
        let formattedDate = formatDateAndTime(dueDate: toDoItem.dueDate!, dueTime: toDoItem.dueTime!)
        dateComponents = setDateComponentsForDueDateTime(for: formattedDate)
      }
    }
    reminder.dueDateComponents = dateComponents
    
    if toDoItem.notification {
      let formattedDate = formatDateAndTime(dueDate: toDoItem.dueDate!, dueTime: toDoItem.dueTime!)
      reminder.alarms = [setAlarm(alarmDate: formattedDate)]
    }
    
    //    if toDoItem.repeatCycle != nil {
    //      setRecurrenceRules()
    //    }
    if toDoItem.context != "" {
      let calendar = calendars.filter({$0.title == toDoItem.context})
      if calendar != [] {
        reminder.calendar = calendar[0]
      } else {
        let newCalendar = EKCalendar(for: .reminder, eventStore: eventStore)
        newCalendar.title = toDoItem.context!
        let sourcesInEventStore = eventStore.sources
        
        
        let filteredSources = sourcesInEventStore.filter { $0.sourceType == .calDAV }
        
        if let icloudSource = filteredSources.first {
          newCalendar.source = icloudSource
        } else {
          let nextFilteredSource = sourcesInEventStore.filter { $0.sourceType == .local }
          if let localSource = nextFilteredSource.first {
            newCalendar.source = localSource
          }
        }
        do {
          try self.eventStore.saveCalendar(newCalendar, commit: true)
          print("calendar creation successful")
        } catch {
          print("cal \(newCalendar.source.title) failed : \(error)")
        }
        //        let subscribedSourceIndex = sourcesInEventStore.index {$0.title == "Subscribed Calendars"}
        //        if let subscribedSourceIndex = subscribedSourceIndex {
        //          newCalendar.source = sourcesInEventStore[subscribedSourceIndex]
        //          do {
        //            try self.eventStore.saveCalendar(newCalendar, commit: true)
        //            print("calendar creation successful")
        //          } catch {
        //            print("cal \(newCalendar.source.title) failed : \(error)")
        //          }
        //        }
        
        do {
          try eventStore.saveCalendar(newCalendar, commit: true)
        } catch let error {
          print("Reminder failed with error \(error.localizedDescription)")
        }
        reminder.calendar = newCalendar
      }
    } else {
      reminder.calendar = eventStore.defaultCalendarForNewReminders()
    }
    
    return reminder
  }
  
  func setNewReminder(toDoItem: ToDo) {
    var reminder = EKReminder(eventStore: eventStore)
    reminder = returnReminder(reminder: reminder, toDoItem: toDoItem)
    do {
      try eventStore.save(reminder,
                          commit: true)
      // reminder.refresh()
    } catch let error {
      print("Reminder failed with error \(error.localizedDescription)")
    }
  }
  
  func editReminder(toDoItem: ToDo) {
    var reminder: EKReminder?
    if toDoItem.isChecked {
      reminder = reminders.filter( {$0.calendarItemIdentifier == toDoItem.calendarRecordID}).first
    } else {
      reminder =
        incompleteReminders.filter( {$0.calendarItemIdentifier == toDoItem.calendarRecordID}).first
    }
    guard var setReminder = reminder else {
      print("error here")
      return
    }
    setReminder = returnReminder(reminder: setReminder, toDoItem: toDoItem)
    
    do {
      try eventStore.save(setReminder, commit: true)
      print("edit update")
    } catch let error {
      print("Reminder failed with error \(error.localizedDescription)")
    }
  }
  
  func removeReminder(toDoItem: ToDo) {
    var reminder: EKReminder?
    if toDoItem.isChecked {
      reminder = reminders.filter( {$0.calendarItemIdentifier == toDoItem.calendarRecordID}).first
    } else {
      reminder =
        incompleteReminders.filter( {$0.calendarItemIdentifier == toDoItem.calendarRecordID}).first
    }
    guard let removeReminder = reminder else {return}
    
    do {
      try eventStore.remove(removeReminder, commit: true)
    } catch let error {
      print("Reminder failed with error \(error.localizedDescription)")
    }
  }
  
  func setAlarm(alarmDate: Date) -> EKAlarm {
    let alarm = EKAlarm(absoluteDate: alarmDate)
    return alarm
  }
  
  func setDateComponentsForDueDateTime(for date: Date) -> DateComponents {
    let calendar = Calendar.current
    let today = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone.current
      , era: nil, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date), second: calendar.component(.second, from: date), nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    return today
  }
  
  func setDateComponentsForDueDateNoTime(for date: Date) -> DateComponents {
    let calendar = Calendar.current
    let today = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone.current
      , era: nil, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    return today
  }
  
  func formatDateAndTime(dueDate: Date, dueTime: String) -> Date {
    let date = Helper.formatDateToString(date: dueDate, format: dateAndTime.monthDateYear)
    let dateTime = ("\(date) \(dueTime)")
    let formattedDateAndTime = Helper.formatStringToDate(date: dateTime, format: "MMM dd, yyyy hh:mm a")
    return formattedDateAndTime
  }
  
  func setRecurrenceRules() {
    let friday = EKRecurrenceDayOfWeek(.friday)
    let saturday = EKRecurrenceDayOfWeek(.saturday)
    let rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [friday, saturday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
  }
  
}
