import UIKit
import EventKit

protocol RemindersUpdatedDelegate: class {
  func updateData()
}

class RemindersController {
  
  var eventStore = EKEventStore()
  var calendarReminderdictionary = [EKCalendar:[EKReminder]]()
  var calendars = [EKCalendar]()
  var reminders = [EKReminder]()
  var incompleteReminders = [EKReminder]()
  weak var delegate: RemindersUpdatedDelegate?
  
  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(storeChanged), name: .EKEventStoreChanged, object: eventStore)
    calendars = eventStore.calendars(for: EKEntityType.reminder)
  }
  
  deinit {
    print("here")
    NotificationCenter.default.removeObserver(storeChanged)
  }
  
  @objc func storeChanged(_ notification: Notification) {
    calendars = eventStore.calendars(for: EKEntityType.reminder)
    delegate?.updateData()
  }
  
  func loadReminderData(completionHandler: @escaping ([EKCalendar:[EKReminder]]) -> ()) {
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
    let formattedDateAndTime = formatStringToDate(date: dateTime, format: "YYYYMMdd hh:mm a")
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
    print("16")
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
    print("original \(date)")
    let calendar = Calendar.current
    let today = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone.current
      , era: nil, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date), second: calendar.component(.second, from: date), nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    print("date \(today)")
    return today
  }
  
  func setDateComponentsForDueDateNoTime(for date: Date) -> DateComponents {
    let calendar = Calendar.current
    let today = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone.current
      , era: nil, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    print("dateNoTime \(today)")
    return today
  }
  
  func formatDateAndTime(dueDate: Date, dueTime: String) -> Date {
    let date = formatDateToString(date: dueDate, format: dateAndTime.monthDateYear)
    print("format duedate \(dueDate)")
    print("format date \(date)")
    let dateTime = ("\(date) \(dueTime)")
    let formattedDateAndTime = formatStringToDate(date: dateTime, format: "MMM dd, yyyy hh:mm a")
    return formattedDateAndTime
  }
  
  func setRecurrenceRules() {
    let friday = EKRecurrenceDayOfWeek(.friday)
  let saturday = EKRecurrenceDayOfWeek(.saturday)
  let rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [friday, saturday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
  }
  
//  var str = "Hello, playground     {!}@#{[32819389]-[2319012]#@{!}"
  
  func setDueDateTimeWithoutNotification(toDoItem: ToDo) -> ToDo {
    var appendedData = "{!}@#{["
    if toDoItem.dueDate != nil {
      appendedData += formatDateToString(date: toDoItem.dueDate!, format: dateAndTime.monthDateYear)
      appendedData += "]["
    } else {
      appendedData += " ][ ]#@{!}"
    }
    if toDoItem.dueTime != nil && toDoItem.dueTime != "" {
      appendedData += toDoItem.dueTime!
      appendedData += "]#@{!}"
    } else {
      appendedData += "]#@{!}"
    }
    
    var notes = toDoItem.notes
    
    if notes.hasSuffix("]#@{!}") {
      let rangeOfZero = notes.range(of: "{!}@#{[", options: .backwards)
      // Get the characters after the last 0
      let suffix = String(describing: notes.prefix(upTo: (rangeOfZero?.lowerBound)!))
      notes = suffix
      notes = String(notes.dropLast(1))
    }
    
    notes += "\n\(appendedData)"
    var formattedToDo = toDoItem
    formattedToDo.notes = notes
    return formattedToDo
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
