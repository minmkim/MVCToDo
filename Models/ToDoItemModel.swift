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
  var checked = false
  var context: String?
  var notes = ""
  var repeatNumber = 0
  var repeatCycle: String?
  var nagNumber = 0
  var cloudRecordID: String
  var notification = false
  var contextSection: String
}

extension ToDo {
  
  init?(remoteRecord: CKRecord) {
    guard let toDoItem = remoteRecord.object(forKey: toDoCloud.toDoItem) as? String,
      let dueDate = remoteRecord.object(forKey: toDoCloud.dueDate) as? Date,
      let dueTime = remoteRecord.object(forKey: toDoCloud.dueTime) as? String,
      let checked = remoteRecord.object(forKey: toDoCloud.checked) as? String,
      let context = remoteRecord.object(forKey: toDoCloud.context) as? String,
      let notes = remoteRecord.object(forKey: toDoCloud.notes) as? String,
      let repeatNumber = remoteRecord.object(forKey: toDoCloud.repeatNumber) as? Int,
      let repeatCycle = remoteRecord.object(forKey: toDoCloud.repeatCycle) as? String,
      let nagNumber = remoteRecord.object(forKey: toDoCloud.nagNumber) as? Int,
      let cloudRecordID = remoteRecord.object(forKey: toDoCloud.cloudRecordID) as? String,
      let notification = remoteRecord.object(forKey: toDoCloud.notification) as? String,
      let contextSection = remoteRecord.object(forKey: toDoCloud.contextSection) as? String
      else {
        return nil
    }
    
    self.toDoItem = toDoItem
    self.dueDate = dueDate
    self.dueTime = dueTime
    if checked == "true"{
      self.checked = true
    } else {
      self.checked = false
    }
    self.context = context
    self.notes = notes
    self.repeatNumber = repeatNumber
    self.repeatCycle = repeatCycle
    self.nagNumber = nagNumber
    self.cloudRecordID = cloudRecordID
    if notification == "true" {
      self.notification = true
    } else {
      self.notification = false
    }
    self.contextSection = contextSection
  }
}
