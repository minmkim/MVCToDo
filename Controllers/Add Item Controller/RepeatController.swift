//
//  RepeatController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/22/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
protocol SendCustomRepeatDelegate: class {
  func sendCustomRepeat(repeatCycle: Reminder.RepeatCycleValues, repeatCycleInterval: Int?, repeatCustomNumber: [Int], repeatCustomRule: Reminder.RepeatCustomRuleValues?)
}

class RepeatController {
  
  weak var delegate: SendCustomRepeatDelegate?
  var currentCycle: Reminder.RepeatCycleValues = .daily
  var repeatCycleInterval: Int?
  var repeatCustomNumber = [Int]()
  var repeatCustomRule: Reminder.RepeatCustomRuleValues?
  
  func numberOfSections() -> Int {
    switch currentCycle {
    case .daily:
      return 1
    case .weekly:
      return 2
    case .monthly:
      return 2
    case .yearly:
      return 2
    }
  }
  
  func numberOfRowsPerSection(for section: Int) -> Int {
    if section == 0 {
      return 2
    } else {
      switch currentCycle {
      case .daily:
        return 0
      case .weekly:
        return 7
      case .monthly:
        return 1
      case .yearly:
        return 1
      }
    }
  }
  
  func savePressed(repeatCycleInterval: Int, repeatCustomNumber: [Int]) {
    switch currentCycle {
    case .daily:
      delegate?.sendCustomRepeat(repeatCycle: currentCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: [], repeatCustomRule: nil)
    case .weekly:
      delegate?.sendCustomRepeat(repeatCycle: currentCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: .daysOfTheWeek)
    case .monthly:
      delegate?.sendCustomRepeat(repeatCycle: currentCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: .daysOfTheMonth)
    case .yearly:
      delegate?.sendCustomRepeat(repeatCycle: currentCycle, repeatCycleInterval: repeatCycleInterval, repeatCustomNumber: repeatCustomNumber, repeatCustomRule: .monthsOfTheYear)
    }
    
  }
  
}
