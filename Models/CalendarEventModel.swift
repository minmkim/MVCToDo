//
//  CalendarEventModel.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/19/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import EventKit

struct CalendarEvent: Codable {
  var title: String
  var location: String?
  var calendar: String
  var dueDate: Date
  var end: Date
  var allDay: Bool?
}
