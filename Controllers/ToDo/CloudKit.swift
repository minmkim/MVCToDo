//
//  CloudKit.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/7/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
  
  var temporaryList = [CKRecord]()
  
  func deleteToCloud(item: ToDo) {
    let container = CKContainer.default()
    let privateDatabase = container.privateCloudDatabase
    let uniqueRecordID = CKRecordID(recordName: item.cloudRecordID)
    let saveOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [uniqueRecordID])
    saveOperation.completionBlock = {
      print("Operation Completed")
    }
    privateDatabase.add(saveOperation)
  }
  
  func editToCloud(item: ToDo) {
    let container = CKContainer.default()
    let privateDatabase = container.privateCloudDatabase
    let uniqueRecordID = CKRecordID(recordName: item.cloudRecordID)
    let newRecord = CKRecord(recordType: toDoRecord.toDo, recordID: uniqueRecordID)
    newRecord[toDoCloud.toDoItem] = item.toDoItem as NSString
    if item.dueDate != nil {
      newRecord[toDoCloud.dueDate] = item.dueDate! as NSDate
    }
    if item.dueTime != nil {
      newRecord[toDoCloud.dueTime] = item.dueTime! as NSString
    }
    
    newRecord[toDoCloud.checked] = String(item.checked) as NSString
    newRecord[toDoCloud.context] = item.context! as NSString
    newRecord[toDoCloud.notes] = item.notes as NSString
    newRecord[toDoCloud.cloudRecordID] = item.cloudRecordID as NSString
    newRecord[toDoCloud.repeatNumber] = item.repeatNumber as NSNumber
    if item.repeatCycle != nil {
      newRecord[toDoCloud.repeatCycle] = item.repeatCycle! as NSString
    }
    newRecord[toDoCloud.notification] = String(item.notification) as NSString
    newRecord[toDoCloud.nagNumber] = item.nagNumber as NSNumber
     newRecord[toDoCloud.contextSection] = item.contextSection as NSString
    print("Here2")
    print(newRecord)
    
    let saveOperation = CKModifyRecordsOperation(recordsToSave: [newRecord], recordIDsToDelete: nil)
    saveOperation.perRecordCompletionBlock = {
      record, error in
      print("Here3")
      print(record)
      if error != nil {
        let errorInfo = error! as NSError
        if errorInfo.code == CKError.serverRecordChanged.rawValue {
          if (CKError.serverRecordChanged.rawValue == errorInfo.code) {
            
            // get information from server to change
            let errorDirectionary: [AnyHashable: Any] = errorInfo.userInfo
            let info = errorDirectionary as NSDictionary
            let clientRecord = info[CKRecordChangedErrorClientRecordKey]! as! CKRecord
            let serverRecord = info[CKRecordChangedErrorServerRecordKey]! as! CKRecord
            let localRecord = info[CKRecordChangedErrorAncestorRecordKey]! as! CKRecord
            
            //all changes by the user will change server despite errors
            
            serverRecord[toDoCloud.toDoItem] = clientRecord[toDoCloud.toDoItem] as! NSString
            serverRecord[toDoCloud.dueDate] = clientRecord[toDoCloud.dueDate] as! NSDate
            serverRecord[toDoCloud.dueTime] = clientRecord[toDoCloud.dueTime] as! NSString
            serverRecord[toDoCloud.checked] = clientRecord[toDoCloud.checked] as! NSString
            serverRecord[toDoCloud.context] = clientRecord[toDoCloud.context] as! NSString
            serverRecord[toDoCloud.notes] = clientRecord[toDoCloud.notes] as! NSString
            serverRecord[toDoCloud.cloudRecordID] = clientRecord[toDoCloud.cloudRecordID] as! NSString
            if clientRecord[toDoCloud.repeatNumber] != nil {
              serverRecord[toDoCloud.repeatNumber] = clientRecord[toDoCloud.repeatNumber] as! NSNumber
            }
            if clientRecord[toDoCloud.repeatCycle] != nil {
              clientRecord[toDoCloud.repeatCycle] = clientRecord[toDoCloud.repeatCycle] as! NSString
            }
            if clientRecord[toDoCloud.nagNumber] != nil {
              serverRecord[toDoCloud.nagNumber] = clientRecord[toDoCloud.nagNumber] as! NSNumber
            }
            
            
            CKContainer.default().privateCloudDatabase.save(serverRecord) {
              record, error in
              if error != nil {
                print(error!.localizedDescription)
              }
            }
          }
        }
      } else {
        print("successful")
      }
    }
    
    saveOperation.completionBlock = {
      print("Operation Completed")
    }
    
    privateDatabase.add(saveOperation)
  }
  
  func saveToCloud(item: ToDo) { //save each addirional item to cloud
    let container = CKContainer.default()
    let privateDatabase = container.privateCloudDatabase
    let uniqueRecordID = CKRecordID(recordName: item.cloudRecordID)
    let record = CKRecord(recordType: toDoRecord.toDo, recordID: uniqueRecordID)
    record[toDoCloud.toDoItem] = item.toDoItem as NSString
    if let dueDate = item.dueDate {
      record[toDoCloud.dueDate] = dueDate as NSDate
    }
    if let dueTime = item.dueTime {
      record[toDoCloud.dueTime] = dueTime as NSString
    }
    record[toDoCloud.checked] = String(item.checked) as NSString
    if let context = item.context {
      record[toDoCloud.context] = context as NSString
    }
    record[toDoCloud.notes] = item.notes as NSString
    record[toDoCloud.cloudRecordID] = item.cloudRecordID as NSString
    record[toDoCloud.repeatNumber] = item.repeatNumber as NSNumber
    if let repeatCycle = item.repeatCycle {
      record[toDoCloud.repeatCycle] = repeatCycle as NSString
    }
    record[toDoCloud.nagNumber] = item.nagNumber as NSNumber
    record[toDoCloud.notification] = String(item.notification) as NSString
    record[toDoCloud.contextSection] = item.contextSection as NSString
    
    privateDatabase.save(record) {
      record, error in
      if let error = error {
        print(error)
        return
      }
      print("sent")
    }
  }
  
  func saveAllToCloud(_ list: [ToDo]) {
    var ckRecords = [CKRecord]()
    var completedRecords = NSMutableSet()
    
    for todo in list {
      let record = CKRecord(recordType: toDoRecord.toDo)
      record[toDoCloud.toDoItem] = todo.toDoItem as NSString
      if let dueDate = todo.dueDate {
        record[toDoCloud.dueDate] = dueDate as NSDate
      }
      if let dueTime = todo.dueTime {
        record[toDoCloud.dueTime] = dueTime as NSString
      }
      record[toDoCloud.checked] = String(todo.checked) as NSString
      if let context = todo.context {
        record[toDoCloud.context] = context as NSString
      }
      record[toDoCloud.notes] = todo.notes as NSString
      record[toDoCloud.cloudRecordID] = todo.cloudRecordID as NSString
      record[toDoCloud.repeatNumber] = todo.repeatNumber as NSNumber
      if let repeatCycle = todo.repeatCycle {
        record[toDoCloud.repeatCycle] = repeatCycle as NSString
      }
      record[toDoCloud.nagNumber] = todo.nagNumber as NSNumber
      record[toDoCloud.notification] = String(todo.notification) as NSString
      record[toDoCloud.contextSection] = todo.contextSection as NSString
      
      ckRecords.append(record)
    }
    
    let saveOperation = CKModifyRecordsOperation(recordsToSave: ckRecords, recordIDsToDelete: nil)
    saveOperation.perRecordCompletionBlock = {
      record, error in
      if error != nil {
        print(error!.localizedDescription)
      }
    }
    
    let totalToDo = list.count
    saveOperation.perRecordProgressBlock = {
      record, progress in
      if progress >= 1 { //completed record
        completedRecords.add(record)
        let totalSavedRecords = completedRecords.count
        let totalProgress = totalSavedRecords / totalToDo
        print("Progress: \(totalProgress)")
      }
    }
    
    saveOperation.completionBlock = {
      print("Operation Completed")
    }
    
    CKContainer.default().privateCloudDatabase.add(saveOperation)
  }
  
  func restoreAllFromCloud() {
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: toDoRecord.toDo, predicate: predicate)
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.resultsLimit = 10
    
    queryOperation.recordFetchedBlock = {
      record in
      self.temporaryList.append(record)
    }
    
    queryOperation.queryCompletionBlock = {
      cursor, error in // cursor indicates if there are more results that need to be downloaded
      if error != nil {
        print("Total records: \(self.temporaryList.count)")
        self.queryServer(cursor!)
      }
    }
    CKContainer.default().privateCloudDatabase.add(queryOperation)
    
  }
  
  // if there are more query, run through again
  func queryServer(_ cursor: CKQueryCursor) {
    let queryOperation = CKQueryOperation(cursor: cursor)
    queryOperation.resultsLimit = 10
    
    queryOperation.recordFetchedBlock = {
      record in
      self.temporaryList.append(record)
    }
    
    queryOperation.queryCompletionBlock = {
      cursor, error in // cursor indicates if there are more results that need to be downloaded
      if error != nil {
        print("Total records: \(self.temporaryList.count)")
        self.queryServer(cursor!)
      }
    }
    
    CKContainer.default().privateCloudDatabase.add(queryOperation)
  }
  
  
  func restoreFromCloud() {
    let container = CKContainer.default()
    let privateDatabase = container.privateCloudDatabase
    let sort = NSSortDescriptor(key: "toDoItem", ascending: false)
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: toDoRecord.toDo, predicate: predicate)
    query.sortDescriptors = [sort]
    privateDatabase.perform(query, inZoneWith: nil) { records, error in
      if error == nil { // There is no error
        guard let records = records else {return}
        for record in records {
          if let toDo = ToDo(remoteRecord: record) {
            //self.toDoList.append(toDo)
          }
        }
        OperationQueue.main.addOperation {
          //self.ListTableView.reloadData()
        }
      }
      else {
        print(error)
      }
    }
  }
}
