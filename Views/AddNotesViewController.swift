//
//  NotesViewController.swift
//  DueLife
//
//  Created by Min Kim on 10/28/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit


class NotesViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var bottom: NSLayoutConstraint!
  
  var noteText: String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
    let todayString = returnTodayDateString()
    notesTextView.delegate = self
    
    if let savedNotes = noteText {
      notesTextView.text = savedNotes
    }
    
    if notesTextView.text == "" {
      self.navigationItem.rightBarButtonItem?.title = "Save"
      notesTextView.text.append("\(todayString)\n")
    } else {
      print("Here")
      self.navigationItem.rightBarButtonItem?.title = "Edit"
      notesTextView.isEditable = false
    }
    
  }
  
  func returnTodayDateString() -> String {
    let formatter = DateFormatter()
    let _ = Calendar.current
    formatter.dateFormat = "MMMM dd, yyyy - hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let todayString = formatter.string(from: Date())
    return todayString
  }
  
  @IBAction func savePress(_ sender: Any) {
    if notesTextView.isEditable == false {
      let todayString = returnTodayDateString()
      notesTextView.isEditable = true
      notesTextView.becomeFirstResponder()
      notesTextView.text.append("\n\(todayString)\n")
      
      // scroll to bottom
      let range = NSMakeRange(notesTextView.text.characters.count - 1, 0)
      notesTextView.scrollRangeToVisible(range)
      
      self.navigationItem.rightBarButtonItem?.title = "Save"
    } else {
      noteText = notesTextView.text
      performSegue(withIdentifier: "UnwindWithNotesSegue", sender: self)
    }
  }
  
  @IBAction func cancelPress(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func sharePress(_ sender: Any) { // share text
    if let shareText = notesTextView.text {
      let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
      present(vc, animated: true)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let todayString = returnTodayDateString()
    if notesTextView.text == ("\(todayString)\n") {
      notesTextView.becomeFirstResponder()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)),  name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWasShown(_ notification: NSNotification) {
    var info = notification.userInfo!
    let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.25, animations: { () -> Void in
      self.bottom.constant = keyboardFrame.size.height
      self.view.layoutIfNeeded()
    })
  }
  
  
  @objc func keyboardWillBeHidden(_ notification: NSNotification) {
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.25, animations: { () -> Void in
      self.bottom.constant = 0
      self.view.layoutIfNeeded()
    })
  }
  
}

