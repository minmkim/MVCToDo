//
//  ToDoItemModel.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/14/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import CloudKit

struct ToDo: Codable {
  
  var toDoItem: String
  var dueDate: Date?
  var dueTime: String?
  var isChecked = false
  var context: String?
  var notes = ""
  var repeatNumber = 0
  var repeatCycle: String?
  var repeatDays: String?
  var calendarRecordID: String
  var notification = false
  var contextParent: String
}
