//
//  NotesViewController.swift
//  DueLife
//
//  Created by Min Kim on 10/28/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit


class NotesViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var bottom: NSLayoutConstraint!
  
  var controller = NotesController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
    notesTextView.delegate = self
    notesTextView.text = controller.setNote()
    
    if notesTextView.text == "" {
      self.navigationItem.rightBarButtonItem?.title = "Save"
      let todayString = controller.returnTodayDateString()
      notesTextView.text.append("\(todayString)\n")
    } else {
      self.navigationItem.rightBarButtonItem?.title = "Edit"
      notesTextView.isEditable = false
    }
  }
  
  @IBAction func savePress(_ sender: Any) {
    if notesTextView.isEditable == false { // edit pressed
      notesTextView.isEditable = true
      notesTextView.becomeFirstResponder()
      let todayString = controller.returnTodayDateString()
      notesTextView.text.append("\n\n\(todayString)\n")
      
      // scroll to bottom
      let range = NSMakeRange(notesTextView.text.count - 1, 0)
      notesTextView.scrollRangeToVisible(range)
      self.navigationItem.rightBarButtonItem?.title = "Save"
    } else { // save pressed
      print(notesTextView.text)
      performSegue(withIdentifier: "UnwindWithNotesSegue", sender: self)
      print("segue2")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "UnwindWithNotesSegue" {
      let destination = segue.destination as! AddItemTableViewController
      print("segue1")
      self.controller.delegate = destination.controller
      controller.sendFinishedNote(notesTextView.text)
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
    if controller.receivedNote == "" {
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

