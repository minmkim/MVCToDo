//
//  AddToDoTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

class AddItemTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {
  
  @IBOutlet weak var contextLabel: UILabel!
  @IBOutlet weak var dueDateLabel: UILabel!
  @IBOutlet weak var dueTimeLabel: UILabel!
  @IBOutlet weak var repeatLabel: UILabel!
  @IBOutlet weak var nagText: UILabel!
  @IBOutlet weak var toDoItemText: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var dueDateField: UITextField!
  @IBOutlet weak var dueTimeField: UITextField!
  @IBOutlet weak var contextField: UITextField!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var notesButton: UIButton!
  @IBOutlet weak var repeatingField: UITextField!
  @IBOutlet weak var dueTimePicker: UIDatePicker!
  @IBOutlet weak var nagLabel: UILabel!
  @IBOutlet weak var nagStepper: UIStepper!
  @IBOutlet weak var repeatPicker: UIPickerView!
  @IBOutlet weak var dueDatePicker: UIDatePicker!
  
  var isDueTimePickerShown: Bool = false {
    didSet {
      setTimePickerTime()
      dueTimePicker.isHidden = !isDueTimePickerShown
    }
  }
  
  var isDueDatePickerShown: Bool = false {
    didSet {
      
      setDatePickerDate()
      dueDatePicker.isHidden = !isDueDatePickerShown
    }
  }
  
  var isrepeatPickerShown: Bool = false {
    didSet {
      repeatPicker.isHidden = !isrepeatPickerShown
    }
  }
  
  let dueDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
  let dueTimePickerCellIndexPath = IndexPath(row: 5, section: 1)
  let repeatPickerCellIndexPath = IndexPath(row: 7, section: 1)
  
  let controller: AddEditToDoController = AddEditToDoController()
  
  // clear buttons in textfield
  @IBAction func repeatClearPress(_ sender: Any) {
    repeatingField.text = ""
    controller.numberRepeatInt = nil
    controller.cycleRepeatString = ""
  }
  @IBAction func dueTimeClearPress(_ sender: Any) {
    dueTimeField.text = ""
  }
  @IBAction func dueDateClearPress(_ sender: Any) {
    dueDateField.text = ""
  }
  
  @IBAction func nagStepperPress(_ sender: Any) {
    if dueTimeField.text == "" {
      nagStepper.isUserInteractionEnabled = false
    } else {
      nagStepper.isUserInteractionEnabled = true
      updateNagNumber()
    }
  }
  
  @IBAction func infoPressed(_ sender: Any) {
    /*  let center = UNUserNotificationCenter.current()
     center.getPendingNotificationRequests { (notifications) in
     print("Count: \(notifications.count)")
     for item in notifications {
     //print(item.content)
     //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.identifier])
     }
     }*/
  }
  
  @IBAction func notesPressed(_ sender: Any) {
    notesButton.backgroundColor = UIColor(red: 0.876, green: 0.876, blue: 0.876, alpha: 1)
    infoButton.backgroundColor = UIColor.white
  }
  
  @IBAction func cancel() {
    if toDoItemText.isFirstResponder {
      toDoItemText.resignFirstResponder()
    }
    if self.navigationItem.title == "Add To Do" {
      navigationController?.dismiss(animated: true)
    } else {
      navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func done() {
    print("Done pressed")
    if toDoItemText.isFirstResponder {
      toDoItemText.resignFirstResponder()
    }
  }
  
  func updateNagNumber() {
    switch nagStepper.value {
    case 0:
      nagLabel.text = "None"
      controller.nagInt = nil
    case 1:
      nagLabel.text = "Every Minute"
      controller.nagInt = Int(nagStepper.value)
    default:
      nagLabel.text = "Every \(Int(nagStepper.value)) Minutes"
      controller.nagInt = Int(nagStepper.value)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let labelStrings = controller.updateLabels()
    
    //[todoitem, context, duedate, duetime, notes, repeatnumber, repeatcycle, nagnumber]
    if labelStrings != [] {
      toDoItemText.text = labelStrings[0]
      contextField.text = labelStrings[1]
      dueDateField.text = labelStrings[2]
      dueTimeField.text = labelStrings[3]
    }
    navigationItem.title = controller.setTitle()
    toDoItemText.delegate = self
    repeatingField.isUserInteractionEnabled = false
    dueDateField.isUserInteractionEnabled = false
    dueTimeField.isUserInteractionEnabled = false
    nagLabel.text = ""
    repeatPicker.showsSelectionIndicator = true
    repeatPicker.delegate = self
    repeatPicker.dataSource = self
    dueTimeField.delegate = self
    
    //set date and time picker
    
    
    if toDoItemText.text == "" {
      toDoItemText.becomeFirstResponder()
      doneButton.isEnabled = false
    } else {
      // if editing, update textfields
    }
    
    if navigationItem.title == "Add To Do" {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    self.navigationController?.navigationBar.tintColor = UIColor.red // color of the back button
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    infoButton.backgroundColor = UIColor(red: 0.876, green: 0.876, blue: 0.876, alpha: 1)
    notesButton.backgroundColor = UIColor.white
    
    if dueTimeField.text == "" {
      nagStepper.isUserInteractionEnabled = false
    } else {
      nagStepper.isUserInteractionEnabled = true
    }
  }  // end viewdidload
  
  // setup date and time picker if coming from editsegue
  func setDatePickerDate() {
    dueDatePicker.datePickerMode = UIDatePickerMode.date
    dueDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    
    if dueDateField.text != "" {
      let date = controller.formatStringToDate(date: dueDateField.text!, format: dateAndTime.monthDateYear)
      dueDatePicker.setDate(date, animated: true)
    }
  }
  
  func setTimePickerTime() {
    dueTimePicker.addTarget(self, action: #selector(timePickerValueChanged), for: UIControlEvents.valueChanged)
    
    dueTimePicker.datePickerMode = UIDatePickerMode.time
    if dueTimeField.text != "" {
      let time = controller.formatStringToDate(date: dueTimeField.text!, format: dateAndTime.hourMinute)
      dueTimePicker.setDate(time, animated: true)
    }
  }
  
  // update time and date field when picker changes
  @objc func datePickerValueChanged(sender:UIDatePicker) {
    dueDateField.text = controller.formatDateToString(date: sender.date, format: dateAndTime.monthDateYear)
  }
  
  @objc func timePickerValueChanged(sender:UIDatePicker) {
    dueTimeField.text = controller.formatDateToString(date: sender.date, format: dateAndTime.hourMinute)
  }
  
  // repeat picker delegate
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  //repeat picker delegate
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return controller.numberRepeat.count
    } else {
      return controller.repeatingNotifications.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 0 {
      return controller.numberRepeat[row]
    } else {
      return controller.repeatingNotifications[row]
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let numberOfRepeat = pickerView.selectedRow(inComponent: 0)
    let cycleRepeat = pickerView.selectedRow(inComponent: 1)
    
    controller.numberRepeatInt = Int(controller.numberRepeat[numberOfRepeat])
    controller.cycleRepeatString = controller.repeatingNotifications[cycleRepeat]  //["Days", "Weeks", "Months"]
    
    if controller.numberRepeatInt == 1 {
      switch controller.cycleRepeatString {
      case "Days"?:
        repeatingField.text = "Every Day"
      case "Weeks"?:
        repeatingField.text = "Every Week"
      case "Months"?:
        repeatingField.text = "Every Month"
      default:
        print("error in selecting picker row")
      }
    } else {
      repeatingField.text = ("Every \(controller.numberRepeat[numberOfRepeat]) \(controller.repeatingNotifications[cycleRepeat])")
    }
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == toDoItemText  { // Switch focus to other text field
      toDoItemText.resignFirstResponder()
    }
    return true
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //  setTheme()
    switch (indexPath.section, indexPath.row) {
    case (dueDatePickerCellIndexPath.section, dueDatePickerCellIndexPath.row):
      if isDueDatePickerShown {
        return 216.0
      } else {
        return 0.0
      }
    case (dueTimePickerCellIndexPath.section, dueTimePickerCellIndexPath.row):
      if isDueTimePickerShown {
        return 216.0
      } else {
        return 0.0
      }
    case (repeatPickerCellIndexPath.section, repeatPickerCellIndexPath.row):
      if isrepeatPickerShown {
        return 216.0
      } else {
        return 0.0
      }
    default:
      tableView.estimatedRowHeight = 44.0
      return UITableViewAutomaticDimension
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let value = NSString(string: toDoItemText.text!).replacingCharacters(in: range, with: string)
    // if value.characters.count > 0 {
    if value.count > 0 {
      self.doneButton.isEnabled = true
    } else {
      self.doneButton.isEnabled = false
    }
    return true
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch (indexPath.section, indexPath.row) {
    case (dueDatePickerCellIndexPath.section, dueDatePickerCellIndexPath.row - 1):
      if isDueDatePickerShown { // close picker if picker was already open
        isDueDatePickerShown = false
      } else if isDueTimePickerShown { // if dueTimePicker was open, close it and open dueDatePicker
        isDueTimePickerShown = false
        isDueDatePickerShown = true
        isrepeatPickerShown = false
        toDoItemText.resignFirstResponder()
      } else if isrepeatPickerShown { // if repeatPicker was open, close it and open dueDatePicker
        isDueDatePickerShown = true
        isDueTimePickerShown = false
        isrepeatPickerShown = false
        toDoItemText.resignFirstResponder()
      } else { // if nothing open, open dueDatePicker
        isDueDatePickerShown = true
        toDoItemText.resignFirstResponder()
      }
      
      tableView.beginUpdates()
      tableView.endUpdates()
      
    case (dueTimePickerCellIndexPath.section, dueTimePickerCellIndexPath.row - 1):
      if dueDateField.text != "" {
        if isDueTimePickerShown {
          isDueTimePickerShown = false
        } else if isDueDatePickerShown {
          isDueDatePickerShown = false
          isDueTimePickerShown = true
          isrepeatPickerShown = false
          toDoItemText.resignFirstResponder()
        } else if isrepeatPickerShown {
          isDueTimePickerShown = true
          isDueDatePickerShown = false
          isrepeatPickerShown = false
          toDoItemText.resignFirstResponder()
        } else {
          isDueTimePickerShown = true
          toDoItemText.resignFirstResponder()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
      }
    case (repeatPickerCellIndexPath.section, repeatPickerCellIndexPath.row - 1):
      if dueTimeField.text != "" {
        if isrepeatPickerShown {
          isrepeatPickerShown = false
        } else if isDueTimePickerShown {
          isDueTimePickerShown = false
          isDueDatePickerShown = false
          isrepeatPickerShown = true
          toDoItemText.resignFirstResponder()
        } else if isDueDatePickerShown {
          isDueDatePickerShown = false
          isDueTimePickerShown = false
          isrepeatPickerShown = true
          toDoItemText.resignFirstResponder()
        } else {
          isrepeatPickerShown = true
          toDoItemText.resignFirstResponder()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
      }
    case (IndexPath(row:8, section:1).section, IndexPath(row:8, section: 1).row):
      if dueTimeField.text == "" { //do not enable nag stepper if time was not added
        nagStepper.isUserInteractionEnabled = false
      } else {
        nagStepper.isUserInteractionEnabled = true
      }
    default:
      break
    }
  }
  
  @IBAction func unwindWithContex(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? ContextSearchViewController {
      let dataRecieved = sourceViewController.newContext
      controller.listOfContext = sourceViewController.listToUse!
      if dataRecieved == "None" {
        contextField.text = ""
      } else {
        contextField.text = dataRecieved
      }
    }
  }
  
  @IBAction func unwindWithNotes(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? NotesViewController {
      let dataReceived = sourceViewController.noteText
      controller.noteText = dataReceived!
    }
    notesButton.backgroundColor = UIColor.white
    infoButton.backgroundColor = UIColor(red: 0.876, green: 0.876, blue: 0.876, alpha: 1)
  }
  
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ContextSegue" {
      print("context segue")
      let controller = segue.destination as! ContextSearchViewController
      controller.listToUse = self.controller.listOfContext
    } else if segue.identifier == "NoteSegue" {
      let controller = segue.destination as! NotesViewController
      controller.noteText = self.controller.noteText
    }
  }
  
  
  
}

