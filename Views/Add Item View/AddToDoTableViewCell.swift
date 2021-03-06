//
//  AddToDoTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import UserNotifications

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
  
  
  //MARK: IB
  
  @IBOutlet var labels: [UILabel]!
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
  @IBOutlet weak var notificationSwitch: UISwitch!
  
  // clear buttons in textfield
  @IBAction func repeatClearPress(_ sender: Any) {
    repeatingField.text = ""
    controller.numberRepeatInt = 0
    controller.cycleRepeatString = ""
  }
  @IBAction func dueTimeClearPress(_ sender: Any) {
    dueTimeField.text = ""
    notificationSwitch.isOn = false
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
  
  @IBAction func NotificationPressed(_ sender: Any) {
    let notificationPermission = UserDefaults.standard.bool(forKey: "NotificationPermission")
    
    if notificationPermission {
      if notificationSwitch.isOn {
        controller.setNotification(true)
      } else {
        controller.setNotification(false)
        controller.nagInt = 0
      }
      //update row heights to reveal nag and repeat
      tableView.beginUpdates()
      tableView.endUpdates()
    } else {
      notificationSwitch.setOn(false, animated: false)
      let alertController = UIAlertController(title: "Unable to set Notifications!", message: "Please go to Settings -> Notifications and give notification permission to Due Life", preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        print("OK")
      }
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func infoPressed(_ sender: Any) {
      let center = UNUserNotificationCenter.current()
     center.getPendingNotificationRequests { (notifications) in
     print("Count: \(notifications.count)")
     for item in notifications {
     print(item.content)
     //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.identifier])
     }
     }
  }
  
  @IBAction func notesPressed(_ sender: Any) {
 //   notesButton.backgroundColor = themeController.backgroundColor
 //   infoButton.backgroundColor = themeController.headerBackgroundColor
  }
  
  @IBAction func cancel() {
    print("cancel button press")
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
    controller.savePressed(toDo: toDoItemText.text!, context: contextField.text ?? "", dueDate: dueDateField.text ?? "", dueTime: dueTimeField.text ?? "")
    if toDoItemText.isFirstResponder {
      toDoItemText.resignFirstResponder()
    }
    if controller.segueIdentity == segueIdentifiers.editFromContextSegue {
      performSegue(withIdentifier: "UnwindToContextToDo", sender: self)
    } else if controller.segueIdentity == segueIdentifiers.addFromContextSegue {
      performSegue(withIdentifier: "UnwindToContextToDo", sender: self)
    } else {
      performSegue(withIdentifier: "UnwindFromToDo", sender: self)
    }
  }
  
  // MARK: Variables
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
  
  let buttonIndexPath = IndexPath(row: 0, section:1)
  let dueDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
  let dueTimePickerCellIndexPath = IndexPath(row: 5, section: 1)
  let repeatFieldIndexPath = IndexPath(row: 7, section: 1)
  let repeatPickerCellIndexPath = IndexPath(row: 8, section: 1)
  let nagFieldIndexPath = IndexPath(row: 9, section: 1)
  var controller: AddEditToDoController!
  var themeController = ThemeController()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = controller.setTitle()
    notificationSwitch.isEnabled = false
    updateLabels()
    themeing()
    // if coming from context field, context should same context
    if contextField.text == "" {
      let context = controller.setContextField()
      if context != "" {
        contextField.text = context
      }
    }
    toDoItemText.delegate = self
    repeatingField.isUserInteractionEnabled = false
    dueDateField.isUserInteractionEnabled = false
    dueTimeField.isUserInteractionEnabled = false
    repeatPicker.showsSelectionIndicator = true
    repeatPicker.delegate = self
    repeatPicker.dataSource = self
    dueTimeField.delegate = self
    
     // color of the back button
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
  }  // end viewdidload
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func themeing() {
    for label in labels {
      label.textColor = themeController.mainTextColor
    }
    if themeController.isDarkTheme {
       toDoItemText.keyboardAppearance = .dark
    } else {
      toDoItemText.keyboardAppearance = .light
    }
    toDoItemText.textColor = themeController.mainTextColor
    contextField.textColor = themeController.mainTextColor
    dueDateField.textColor = themeController.mainTextColor
    dueTimeField.textColor = themeController.mainTextColor
    repeatingField.textColor = themeController.mainTextColor
    nagLabel.textColor = themeController.mainTextColor
    self.tableView.backgroundColor = themeController.backgroundColor
    infoButton.backgroundColor = themeController.backgroundColor
    notesButton.backgroundColor = themeController.headerBackgroundColor
    if navigationController?.navigationBar.barTintColor != .black && themeController.mainThemeColor != navigationController?.navigationBar.barTintColor {
      infoButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      notesButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
    } else {
      infoButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      notesButton.setTitleColor(themeController.mainThemeColor, for: .normal)
    }
    dueDatePicker.setValue(themeController.mainTextColor, forKeyPath: "textColor")
    dueTimePicker.setValue(themeController.mainTextColor, forKey: "textColor")
    toDoItemText.attributedPlaceholder = NSAttributedString(string: "To Do", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    contextField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    dueDateField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    dueTimeField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    repeatingField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
  }
  
  func updateLabels() {
    let labelStrings = controller.updateLabels()
    //[todoitem, context, duedate, duetime, notes, repeatLabel, nagText, notification]
    if labelStrings != [] {
      self.navigationController?.navigationBar.tintColor = .white
      DispatchQueue.main.async {
        self.toDoItemText.text = labelStrings[0]
        self.contextField.text = labelStrings[1]
        self.dueDateField.text = labelStrings[2]
        self.dueTimeField.text = labelStrings[3]
        self.repeatingField.text = labelStrings[5]
        self.nagLabel.text = labelStrings[6]
        print("notification: \(labelStrings[7])")
        if labelStrings[7] == "true" {
          self.notificationSwitch.isOn = true
          print(self.notificationSwitch.isOn)
          self.tableView.reloadData()
        }
        if self.dueTimeField.text != "" {
          self.notificationSwitch.isEnabled = true
        }
      }
    } else {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
      self.navigationController?.navigationBar.tintColor = .white
      
      let time = DispatchTime.now() + 0.2
      DispatchQueue.main.asyncAfter(deadline: time) {
        self.toDoItemText.becomeFirstResponder()
      }
      doneButton.isEnabled = false
    }
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = themeController.backgroundColor
  }
  
  //MARK: Stepper
  func updateNagNumber() {
    switch nagStepper.value {
    case 0:
      nagLabel.text = "None"
       controller.nagInt = 0
    case 1:
      nagLabel.text = "Every Minute"
      controller.nagInt = Int(nagStepper.value)
    default:
      nagLabel.text = "Every \(Int(nagStepper.value)) Minutes"
      controller.nagInt = Int(nagStepper.value)
    }
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
  
  // MARK: tableView
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
    case (buttonIndexPath.section, buttonIndexPath.row):
      return 30.0
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
    case (repeatFieldIndexPath.section, repeatFieldIndexPath.row):
      if notificationSwitch.isOn == false {
        return 0.0
      } else {
        return 44.0
      }
    case (repeatPickerCellIndexPath.section, repeatPickerCellIndexPath.row):
      if notificationSwitch.isOn == false {
        return 0.0
      } else {
        if isrepeatPickerShown {
          return 216.0
        } else {
          return 0.0
        }
      }
    case (nagFieldIndexPath.section, nagFieldIndexPath.row):
      if notificationSwitch.isOn == false {
        return 0.0
      } else {
        return 44.0
      }
    default:
      tableView.estimatedRowHeight = 44.0
      return 44.0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(nagStepper.isUserInteractionEnabled)
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
    case (nagFieldIndexPath.section, nagFieldIndexPath.row):
      if dueTimeField.text == "" { //do not enable nag stepper if time was not added
        nagStepper.isUserInteractionEnabled = false
      } else {
        nagStepper.isUserInteractionEnabled = true
      }
    default:
      break
    }
  }
  
  // MARK: segue
  @IBAction func unwindWithContex(sender: UIStoryboardSegue) {
    contextField.text = controller.updateContextField()
  }
  
  @IBAction func unwindWithNotes(sender: UIStoryboardSegue) {
    notesButton.backgroundColor = themeController.headerBackgroundColor
    infoButton.backgroundColor = themeController.backgroundColor
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.noteSegue {
      let controller = segue.destination as! NotesViewController
      self.controller.delegate = controller.controller
      self.controller.setNotes()
    }
  }
  
}

