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
  var dueDate: String?
  var dueTime: String?
  var checked: Bool
  var context: String?
  var notes: String?
  var repeatNumber: Int?
  var repeatCycle: String?
  var nagNumber: Int?
  var cloudRecordID: String
}

extension ToDo {
  
  init?(toDoItem: String, cloudRecordID: String) {
    self.toDoItem = toDoItem
    self.checked = false
    self.cloudRecordID = cloudRecordID
    
  }
  
  init?(remoteRecord: CKRecord) {
    guard let toDoItem = remoteRecord.object(forKey: toDoCloud.toDoItem) as? String,
      let dueDate = remoteRecord.object(forKey: toDoCloud.dueDate) as? String,
      let dueTime = remoteRecord.object(forKey: toDoCloud.dueTime) as? String,
      let checked = remoteRecord.object(forKey: toDoCloud.checked) as? String,
      let context = remoteRecord.object(forKey: toDoCloud.context) as? String,
      let notes = remoteRecord.object(forKey: toDoCloud.notes) as? String,
      let repeatNumber = remoteRecord.object(forKey: toDoCloud.repeatNumber) as? Int,
      let repeatCycle = remoteRecord.object(forKey: toDoCloud.repeatCycle) as? String,
      let nagNumber = remoteRecord.object(forKey: toDoCloud.nagNumber) as? Int,
      let cloudRecordID = remoteRecord.object(forKey: toDoCloud.cloudRecordID) as? String
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
  }
}
