//
//  NotesController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/24/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation

protocol SavedNoteDelegate: class {
  func returnSavedNote(_ notes: String)
}

class NotesController: NotesDelegate {
  
  weak var delegate: SavedNoteDelegate?
  var receivedNote = ""
  
  func sendNotes(_ notes: String) {
    receivedNote = notes
  }
  
  func setNote() -> String {
    return receivedNote
  }
  
  func sendFinishedNote(_ notes: String) {
    print("sending: \(notes)")
    delegate?.returnSavedNote(notes)
  }

  func returnTodayDateString() -> String {
    let formatter = DateFormatter()
    let _ = Calendar.current
    formatter.dateFormat = "MMMM dd, yyyy - hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let todayString = formatter.string(from: Date())
    return todayString
  }
  
  
}
