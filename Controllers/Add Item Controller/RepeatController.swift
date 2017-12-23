//
//  RepeatController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/22/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

class RepeatController {
  
  enum DisplayCycle {
    case daily
    case weekly
    case monthly
    case yearly
  }
  
  var currentCycle: DisplayCycle = .daily
  
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
  
  
  
  
  
  
  
  
  
  
  
}
