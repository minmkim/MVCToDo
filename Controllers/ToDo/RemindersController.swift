import UIKit
import EventKit

protocol RemindersUpdatedDelegate: class {
  func updateData()
}

class RemindersController {
  
  let eventStore = EKEventStore()
  var calendars = [EKCalendar]()
  var incompleteReminderList = [Reminder]()
  var completeReminderList = [Reminder]()
  weak var delegate: RemindersUpdatedDelegate?
  
  init() {
    print("init reminderscontroller")
    NotificationCenter.default.addObserver(self, selector: #selector(storeChanged), name: .EKEventStoreChanged, object: eventStore)
    
  }
  
  deinit {
    print("deinit reminderscontroller")
    NotificationCenter.default.removeObserver(storeChanged)
  }
  
  @objc func storeChanged(_ notification: Notification) {
    calendars = eventStore.calendars(for: EKEntityType.reminder)
    delegate?.updateData()
  }
  
  func setNewReminder(ekReminder: EKReminder) {
    do {
      try eventStore.save(ekReminder,
                          commit: true)
      let newReminder = Reminder(ekReminder)
      incompleteReminderList.append(newReminder)
    } catch let error {
      print("Reminder failed with error \(error.localizedDescription)")
    }
  }
  
  func editReminder(reminder: Reminder) {
    guard let reminderToEdit = reminder.reminder else {return}
    do {
      try eventStore.save(reminderToEdit, commit: true)
    } catch let error {
      print("Reminder failed with error \(error.localizedDescription)")
    }
  }
  
  func removeReminder(reminder: Reminder) {
    guard let reminderToDelete = reminder.reminder else {return}
    do {
      try eventStore.remove(reminderToDelete, commit: true)
      if reminder.isChecked {
        completeReminderList = completeReminderList.filter( {$0.calendarRecordID != reminderToDelete.calendarItemIdentifier})
      } else {
        incompleteReminderList = incompleteReminderList.filter( {$0.calendarRecordID != reminderToDelete.calendarItemIdentifier})
      }
    } catch let error {
      print("Reminder failed with error \(error.localizedDescription)")
    }
  }

  
  func loadReminderData(completionHandler: @escaping ([Reminder]) -> ()) {
    calendars = []
    incompleteReminderList = []
    calendars = eventStore.calendars(for: EKEntityType.reminder)
    let incompletePredicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
    eventStore.fetchReminders(matching: incompletePredicate, completion: { [unowned self](reminders: [EKReminder]?) -> Void in
      
      if reminders != nil {
        for reminder in reminders! {
          autoreleasepool {
            let newReminder = Reminder(reminder)
            self.incompleteReminderList.append(newReminder)
          }
          
        }
        self.incompleteReminderList = self.incompleteReminderList.sorted(by: {($0.dueDate ?? Date()) < ($1.dueDate ?? Date())})
      } else {
        print("error, reminders list is empty")
      }
      
//      self.incompleteReminders = reminders!
//      for calendar in self.calendars {
//        let calendarList = self.incompleteReminders.filter({$0.calendar == calendar})
//        self.calendarReminderdictionary[calendar] = calendarList
//      }
      completionHandler(self.incompleteReminderList)
    })
  }
  
  func loadCompletedReminderData(completionHandler: @escaping ([Reminder]) -> ()) {
    completeReminderList = []
    calendars =
      eventStore.calendars(for: EKEntityType.reminder)
    let completePredicate = eventStore.predicateForCompletedReminders(withCompletionDateStarting: nil, ending: nil, calendars: nil)
    eventStore.fetchReminders(matching: completePredicate, completion: { [unowned self](reminders: [EKReminder]?) -> Void in
      if reminders != nil {
        for reminder in reminders! {
          let newReminder = Reminder(reminder)
          self.completeReminderList.append(newReminder)
        }
        self.completeReminderList = self.completeReminderList.sorted(by: {($0.dueDate ?? Date()) < ($1.dueDate ?? Date())})
      } else {
        print("error, reminders list is empty")
      }
      completionHandler(self.completeReminderList)
    })
  }
  
  func createReminder(reminderTitle: String, dueDate: Date?, dueTime: String?, context: String?, notes: String?, notification: Bool, notifyDate: Date?, isRepeat: Bool, repeatCycle: Reminder.RepeatCycleValues?, repeatCycleInterval: Int?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues, endRepeatDate: Date?) -> EKReminder{
    let reminder = EKReminder(eventStore: eventStore)
    reminder.title = reminderTitle
    
    var dateComponents: DateComponents? = nil
    if let date = dueDate {
      if let time = dueTime {
        let formattedDate = formatDateAndTime(dueDate: date, dueTime: time)
        dateComponents = setDateComponentsForDueDateTime(for: formattedDate)
      } else {
       dateComponents = setDateComponentsForDueDateNoTime(for: date)
      }
    }
    reminder.dueDateComponents = dateComponents
    reminder.isCompleted = false
    if let setContext = context {
      let calendar = calendars.filter({$0.title == setContext})
      if calendar != [] { // if calendar array is not empty
        reminder.calendar = calendar.first
      } else { // if creating a new calendar
        let newCalendar = EKCalendar(for: .reminder, eventStore: eventStore)
        newCalendar.title = setContext
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
        reminder.calendar = newCalendar
      }
    } else { // if nil use default
      reminder.calendar = eventStore.defaultCalendarForNewReminders()
    }
    
    if let newNote = notes {
      reminder.notes = newNote
    }
    
    if notification {
      if let alarmDate = notifyDate {
        let newAlarm = setAlarm(alarmDate: alarmDate)
        reminder.alarms = [newAlarm]
      }
    }
    
    if isRepeat {
      reminder.recurrenceRules = [setRecurrenceRules(repeatCycle: repeatCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: repeatCustomRule, endRepeat: endRepeatDate)]
    }
    return reminder
  }
  
  
  func setRecurrenceRules(repeatCycle: Reminder.RepeatCycleValues?, repeatCycleInterval: Int?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues, endRepeat: Date?) -> EKRecurrenceRule {
    var endRepeatDate: EKRecurrenceEnd?
    if let endDate = endRepeat {
      endRepeatDate = EKRecurrenceEnd(end: endDate)
    }
    var rule = EKRecurrenceRule()
    switch repeatCycle {
    case .daily?:
      rule = EKRecurrenceRule(recurrenceWith: .daily, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
      
    case .weekly?:
      if repeatCustomRule == .daysOfTheWeek {
        var dayOfWeek = [EKRecurrenceDayOfWeek]()
        for day in repeatCustomNumber {
          switch day {
          case 0:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.sunday))
          case 1:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.monday))
          case 2:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.tuesday))
          case 3:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.wednesday))
          case 4:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.thursday))
          case 5:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.friday))
          case 6:
            dayOfWeek.append(EKRecurrenceDayOfWeek(.saturday))
          default:
            print("8 days in a week?")
          }
        }
        rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: dayOfWeek, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRepeatDate)
      } else {
        rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRepeatDate)
      }
      
    case .monthly?:
      if repeatCustomRule == .daysOfTheMonth {
        rule = EKRecurrenceRule(recurrenceWith: .monthly, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: nil, daysOfTheMonth: (repeatCustomNumber as [NSNumber]), monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRepeatDate)
      } else {
        rule = EKRecurrenceRule(recurrenceWith: .monthly, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRepeatDate)
      }
      
    case .yearly?:
      if repeatCustomRule == .monthsOfTheYear {
        rule = EKRecurrenceRule(recurrenceWith: .yearly, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: (repeatCustomNumber as [NSNumber]), weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRepeatDate)
      } else {
        rule = EKRecurrenceRule(recurrenceWith: .yearly, interval: (repeatCycleInterval ?? 1), daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endRepeatDate)
      }
    default:
      print("error for setting recurrence rule")
    }
    
    
    return rule
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
    let date = Helper.formatDateToString(date: dueDate, format: dateAndTime.monthDateYear)
    print("format duedate \(dueDate)")
    print("format date \(date)")
    let dateTime = ("\(date) \(dueTime)")
    let formattedDateAndTime = Helper.formatStringToDate(date: dateTime, format: "MMM dd, yyyy hh:mm a")
    return formattedDateAndTime
  }
  
  func formatDateForAlarm(dueDate: String, dueTime: String) -> Date {
    let dateTime = ("\(dueDate) \(dueTime)")
    let formattedDateAndTime = Helper.formatStringToDate(date: dateTime, format: "YYYYMMdd hh:mm a")
    return formattedDateAndTime
  }
  
  
//  var str = "Hello, playground     {!}@#{[32819389]-[2319012]#@{!}"
  
//  func setDueDateTimeWithoutNotification(toDoItem: ToDo) -> ToDo {
//    var appendedData = "{!}@#{["
//    if toDoItem.dueDate != nil {
//      appendedData += formatDateToString(date: toDoItem.dueDate!, format: dateAndTime.monthDateYear)
//      appendedData += "]["
//    } else {
//      appendedData += " ][ ]#@{!}"
//    }
//    if toDoItem.dueTime != nil && toDoItem.dueTime != "" {
//      appendedData += toDoItem.dueTime!
//      appendedData += "]#@{!}"
//    } else {
//      appendedData += "]#@{!}"
//    }
//
//    var notes = toDoItem.notes
//
//    if notes.hasSuffix("]#@{!}") {
//      let rangeOfZero = notes.range(of: "{!}@#{[", options: .backwards)
//      // Get the characters after the last 0
//      let suffix = String(describing: notes.prefix(upTo: (rangeOfZero?.lowerBound)!))
//      notes = suffix
//      notes = String(notes.dropLast(1))
//    }
//
//    notes += "\n\(appendedData)"
//    var formattedToDo = toDoItem
//    formattedToDo.notes = notes
//    return formattedToDo
//  }

  
}
