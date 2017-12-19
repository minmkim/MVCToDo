//
//  File.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit

struct Reminder {
  
  var reminder: EKReminder!
  var reminderTitle: String!
  var dueDate: Date?
  var dueTime: String?
  var isChecked = false
  var context: String?
  var contextParent: String?
  var notes: String?
  var isNotification = false {
    didSet {
      if isNotification == false {
        notifyDate = nil
      }
    }
  }
  var notifyDate: Date?
  var isRepeat = false {
    didSet {
      if isRepeat == false {
        repeatCycleInterval = nil
        repeatCycle = nil
        repeatCustomNumber = []
        repeatCustomRule = nil
        endRepeatDate = nil
      }
    }
  }
  var repeatCycleInterval: Int?
  var repeatCycle: RepeatCycleValues?
  var repeatCustomNumber: [Int]
  var repeatCustomRule: RepeatCustomRuleValues?
  var endRepeatDate: Date?
  var calendarRecordID: String
  
  
  
  
  func returnRecurrenceRule() -> EKRecurrenceRule {
    var repeatCycleRule: EKRecurrenceFrequency!
    var recurrenceRule: EKRecurrenceRule!
    switch repeatCycle {
    case .daily?:
      repeatCycleRule = .daily
    case .weekly?:
      repeatCycleRule = .weekly
    case .monthly?:
      repeatCycleRule = .monthly
    case .yearly?:
      repeatCycleRule = .yearly
    default:
      print("repeatcycle error")
    }
    
    if let repeatCustomRule = self.repeatCustomRule {
      switch repeatCustomRule {
      case .daysOfTheWeek:
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
        if endRepeatDate != nil {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: dayOfWeek, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: endRepeatDate!))
        } else {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: dayOfWeek, daysOfTheMonth: repeatCustomNumber as [NSNumber], monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        }
        
      case .daysOfTheMonth:
        if endRepeatDate != nil {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: repeatCustomNumber as [NSNumber], monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: endRepeatDate!))
        } else {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: repeatCustomNumber as [NSNumber], monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        }
        
      case .monthsOfTheYear:
        if endRepeatDate != nil {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: repeatCustomNumber as [NSNumber], weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: endRepeatDate!))
        } else {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: repeatCustomNumber as [NSNumber], setPositions: nil, end: nil)
        }
        
      case .weeksOfTheYear:
        if endRepeatDate != nil {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: repeatCustomNumber as [NSNumber], daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: endRepeatDate!))
        } else {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: repeatCustomNumber as [NSNumber], daysOfTheYear: nil, setPositions: nil, end: nil)
        }
        
      case .daysOfTheYear:
        if endRepeatDate != nil {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: repeatCustomNumber as [NSNumber], setPositions: nil, end: EKRecurrenceEnd(end: endRepeatDate!))
        } else {
          recurrenceRule = EKRecurrenceRule(recurrenceWith: repeatCycleRule, interval: repeatCycleInterval!, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: repeatCustomNumber as [NSNumber], setPositions: nil, end: nil)
        }
      }
    }
    return recurrenceRule
  }
  
  enum RepeatCycleValues {
    case daily
    case weekly
    case monthly
    case yearly
  }
  
  enum RepeatCustomRuleValues {
    case daysOfTheWeek
    case daysOfTheMonth
    case monthsOfTheYear
    case weeksOfTheYear
    case daysOfTheYear
  }
  
  init(_ unformattedReminder: EKReminder) {
    let reminderTitle = unformattedReminder.title ?? ""
    let dueDate = unformattedReminder.dueDateComponents?.date
    var dueTime: String? = nil
    if unformattedReminder.dueDateComponents?.date != nil {
      dueTime = Helper.formatDateToString(date: (unformattedReminder.dueDateComponents?.date)!, format: dateAndTime.hourMinute)
    }
    let isChecked = unformattedReminder.isCompleted
    let context = unformattedReminder.calendar.title
    let notes = unformattedReminder.notes
    
    var alarmDate: Date?
    var isNotification = false
    if unformattedReminder.hasAlarms {
      isNotification = true
      alarmDate = unformattedReminder.alarms?.first?.absoluteDate
    }
    var isRepeat = false
    var repeatCycleInterval: Int?
    var repeatCycle: Reminder.RepeatCycleValues?
    var repeatCustomNumber = [Int]()
    var repeatCustomRule: Reminder.RepeatCustomRuleValues?
    var endRepeatDate: Date?
    let calendarRecordID = unformattedReminder.calendarItemIdentifier
    if unformattedReminder.hasRecurrenceRules {
      isRepeat = true
      let recurrenceRules = unformattedReminder.recurrenceRules?.first
      repeatCycleInterval = recurrenceRules?.interval
      let number = recurrenceRules?.frequency
      switch number {
      case .daily?:
        repeatCycle = .daily
      case .weekly?:
        repeatCycle = .weekly
      case .monthly?:
        repeatCycle = .monthly
      case .yearly?:
        repeatCycle = .yearly
      default:
        print("repeatcycle is nil")
        repeatCycle = nil
      }
      if let daysOfWeek = recurrenceRules?.daysOfTheWeek {
        repeatCustomRule = .daysOfTheWeek
        for day in daysOfWeek {
          switch day {
          case EKRecurrenceDayOfWeek(.sunday):
            repeatCustomNumber.append(0)
          case EKRecurrenceDayOfWeek(.monday):
            repeatCustomNumber.append(1)
          case EKRecurrenceDayOfWeek(.tuesday):
            repeatCustomNumber.append(2)
          case EKRecurrenceDayOfWeek(.wednesday):
            repeatCustomNumber.append(3)
          case EKRecurrenceDayOfWeek(.thursday):
            repeatCustomNumber.append(4)
          case EKRecurrenceDayOfWeek(.friday):
            repeatCustomNumber.append(5)
          case EKRecurrenceDayOfWeek(.saturday):
            repeatCustomNumber.append(7)
          default:
            print("are there 8 days in a week?")
          }
        }
      }
      
      if let daysOfTheMonth = recurrenceRules?.daysOfTheMonth {
        repeatCustomRule = .daysOfTheMonth
        repeatCustomNumber = daysOfTheMonth as! [Int]
      }
      
      if let monthsOfTheYear = recurrenceRules?.monthsOfTheYear {
        repeatCustomRule = .daysOfTheYear
        repeatCustomNumber = monthsOfTheYear as! [Int]
      }
      
      if let weeksOfTheYear = recurrenceRules?.weeksOfTheYear {
        repeatCustomRule = .weeksOfTheYear
        repeatCustomNumber = weeksOfTheYear as! [Int]
      }
      
      if let daysOfTheYear = recurrenceRules?.daysOfTheMonth {
        repeatCustomRule = .daysOfTheYear
        repeatCustomNumber = daysOfTheYear as! [Int]
      }
      
      endRepeatDate = recurrenceRules?.recurrenceEnd?.endDate
    }
    self.reminder = unformattedReminder
    self.reminderTitle = reminderTitle
    self.dueDate = dueDate
    self.dueTime = dueTime
    self.isChecked = isChecked
    self.context = context
    self.contextParent = nil
    self.notes = notes
    self.isNotification = isNotification
    self.notifyDate = alarmDate
    self.isRepeat = isRepeat
    self.repeatCycle = repeatCycle
    self.repeatCycleInterval = repeatCycleInterval
    self.repeatCustomNumber = repeatCustomNumber
    self.repeatCustomRule = repeatCustomRule
    self.endRepeatDate = endRepeatDate
    self.calendarRecordID = calendarRecordID
  }
  
}
