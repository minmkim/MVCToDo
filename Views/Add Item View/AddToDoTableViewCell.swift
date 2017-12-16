//
//  AddToDoTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/17/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import UserNotifications
import EventKit

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
  
  //MARK: IB
  @IBOutlet var labels: [UILabel]!
  @IBOutlet weak var toDoItemText: UITextField!
  @IBOutlet weak var dueDateField: UITextField!
  @IBOutlet weak var dueTimeField: UITextField!
  @IBOutlet weak var contextField: UITextField!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var notesButton: UIButton!
  @IBOutlet weak var repeatingField: UITextField!
  @IBOutlet weak var dueTimePicker: UIDatePicker!
  @IBOutlet weak var dueDatePicker: UIDatePicker!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var parentField: UITextField!
  @IBOutlet weak var todayButton: UIButton!
  @IBOutlet weak var tomorrowButton: UIButton!
  @IBOutlet weak var customButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var customRepeatButton: UIButton!
  @IBOutlet weak var monthlyRepeatButton: UIButton!
  @IBOutlet weak var weeklyRepeatButton: UIButton!
  @IBOutlet weak var dailyRepeatButton: UIButton!
  @IBOutlet weak var neverRepeatButton: UIButton!
  
  @IBAction func repeatButtonPressed(_ sender: Any) {
    print("here")
  }

  @IBAction func dueTimeClearPress(_ sender: Any) {
    dueTimeField.text = ""
    notificationSwitch.isOn = false
  }
  @IBAction func dueDateClearPress(_ sender: Any) {
    dueDateField.text = ""
  }
  
  @IBAction func todayButtonPressed(_ sender: Any) {
    dueDateField.text = controller.formatDateToString(date: Date(), format: dateAndTime.monthDateYear)
    
  }
  @IBAction func tomorrowButtonPressed(_ sender: Any) {
    dueDateField.text = controller.calculateDateAndFormatDateToString(days: 1, date: Date(), format: dateAndTime.monthDateYear)
  }
  @IBAction func customButtonPressed(_ sender: Any) {
    isDueDatePickerShown = true
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  @IBAction func saveButtonPressed(_ sender: Any) {
    done()
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    cancel()
  }
  @IBAction func NotificationPressed(_ sender: Any) {
    let notificationPermission = UserDefaults.standard.bool(forKey: "NotificationPermission")
    
    if notificationPermission {
      if notificationSwitch.isOn {
        controller.setNotification(true)
      } else {
        controller.setNotification(false)
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
    if toDoItemText.isFirstResponder {
      toDoItemText.resignFirstResponder()
    }
    if self.navigationItem.title == "Add To Do" {
      if controller.segueIdentity == nil {
        performSegue(withIdentifier: "UnwindToCancel", sender: self)
      }
      navigationController?.dismiss(animated: true)
    } else {
      navigationController?.popViewController(animated: true)
    }
    controller = nil
  }
  
  func done() {
    controller.savePressed(toDo: toDoItemText.text!, context: contextField.text ?? "", dueDate: dueDateField.text ?? "", dueTime: dueTimeField.text ?? "")
    if toDoItemText.isFirstResponder {
      toDoItemText.resignFirstResponder()
    }
    if controller.segueIdentity == segueIdentifiers.editFromContextSegue {
      performSegue(withIdentifier: "UnwindToContextToDo", sender: self)
    } else if controller.segueIdentity == segueIdentifiers.addFromContextSegue {
      performSegue(withIdentifier: "UnwindToContextToDo", sender: self)
    } else if controller.segueIdentity == segueIdentifiers.addFromTodaySegue || controller.segueIdentity == segueIdentifiers.editFromTodaySegue {
      performSegue(withIdentifier: segueIdentifiers.unwindToTodayView, sender: self)
    } else {
      print("unwind4")
      performSegue(withIdentifier: "UnwindFromToDo", sender: self)
      controller.toDoModelController = nil
    }
  }
  
  
  
  // MARK: Variables
  var isDueDatePressed = false
  var isRepeatShown = false
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
  
  let buttonIndexPath = IndexPath(row: 0, section:1)
  let parentFieldIndexPath = IndexPath(row: 2, section: 1)
  let dueDatePickerCellIndexPath = IndexPath(row: 4, section: 1)
  let dueTimePickerCellIndexPath = IndexPath(row: 6, section: 1)
  let repeatFieldIndexPath = IndexPath(row: 8, section: 1)
  let repeatPickerCellIndexPath = IndexPath(row: 9, section: 1)
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
    if dueDateField.text == "" {
      let dateString = controller.returnTodayDate()
      dueDateField.text = dateString
    }
    toDoItemText.delegate = self
    repeatingField.isUserInteractionEnabled = false
    dueDateField.isUserInteractionEnabled = false
    dueTimeField.isUserInteractionEnabled = false
    dueTimeField.delegate = self
     // color of the back button
    //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.navigationItem.setLeftBarButton(nil, animated: true)
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
      infoButton.backgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
      notesButton.backgroundColor = .black
    } else {
      toDoItemText.keyboardAppearance = .light
      infoButton.backgroundColor = .white
      notesButton.backgroundColor = .groupTableViewBackground
    }
    toDoItemText.textColor = themeController.mainTextColor
    contextField.textColor = themeController.mainTextColor
    parentField.textColor = themeController.mainTextColor
    dueDateField.textColor = themeController.mainTextColor
    dueTimeField.textColor = themeController.mainTextColor
    repeatingField.textColor = themeController.mainTextColor
    
    self.tableView.backgroundColor = themeController.addBackgroundColor
    if navigationController?.navigationBar.barTintColor != .black && themeController.mainThemeColor != navigationController?.navigationBar.barTintColor {
      infoButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      notesButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      notificationSwitch.tintColor = navigationController?.navigationBar.barTintColor
      notificationSwitch.onTintColor = navigationController?.navigationBar.barTintColor
      todayButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      tomorrowButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      customButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      saveButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
      cancelButton.setTitleColor(navigationController?.navigationBar.barTintColor, for: .normal)
    } else {
      infoButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      notesButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      notificationSwitch.tintColor = themeController.mainThemeColor
      notificationSwitch.onTintColor = themeController.mainThemeColor
      todayButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      tomorrowButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      customButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      saveButton.setTitleColor(themeController.mainThemeColor, for: .normal)
      cancelButton.setTitleColor(themeController.mainThemeColor, for: .normal)
    }
    dueDatePicker.setValue(themeController.mainTextColor, forKeyPath: "textColor")
    dueTimePicker.setValue(themeController.mainTextColor, forKey: "textColor")
    toDoItemText.attributedPlaceholder = NSAttributedString(string: "To Do", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    contextField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    parentField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    dueDateField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    dueTimeField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    repeatingField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
  }
  
  func updateLabels() {
    let labelStrings = controller.updateLabels()
    //[todoitem, context, duedate, duetime, parent, repeatLabel, notification]
    if labelStrings != [] {
      self.navigationController?.navigationBar.tintColor = .white
      DispatchQueue.main.async {
        self.toDoItemText.text = labelStrings[0]
        self.contextField.text = labelStrings[1]
        self.dueDateField.text = labelStrings[2]
        self.dueTimeField.text = labelStrings[3]
        self.parentField.text = labelStrings[4]
        self.repeatingField.text = labelStrings[5]
        if labelStrings[6] == "true" {
          self.notificationSwitch.isOn = true
          print(self.notificationSwitch.isOn)
        }
        if self.dueTimeField.text != "" {
          self.notificationSwitch.isEnabled = true
        }
        self.tableView.reloadData()
      }
    } else {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
      self.navigationController?.navigationBar.tintColor = .white
      
      let time = DispatchTime.now() + 0.2
      DispatchQueue.main.asyncAfter(deadline: time) {
        self.toDoItemText.becomeFirstResponder()
      }
      saveButton.isEnabled = false
    }
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = themeController.addTextFieldColor
  }
 
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let value = NSString(string: toDoItemText.text!).replacingCharacters(in: range, with: string)
    // if value.characters.count > 0 {
    if value.count > 0 {
      self.saveButton.isEnabled = true
    } else {
      self.saveButton.isEnabled = false
    }
    return true
  }
  
  // MARK: tableView
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
    case (buttonIndexPath.section, buttonIndexPath.row):
      return 30.0
    case (parentFieldIndexPath.section, parentFieldIndexPath.row):
      if contextField.text != "" {
        return 44.0
      } else {
        return 0.0
      }
    case (dueDatePickerCellIndexPath.section, dueDatePickerCellIndexPath.row):
      if isDueDatePressed == true && isDueDatePickerShown == false {
        return 30.0
      } else if isDueDatePressed && isDueDatePickerShown {
        return 246.0
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
        if isRepeatShown {
          return 30
        } else {
          return 0.0
        }
      }
    default:
      tableView.estimatedRowHeight = 44.0
      return 44.0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      let cell = tableView.cellForRow(at: indexPath)
      cell?.selectionStyle = UITableViewCellSelectionStyle.none
    case (dueDatePickerCellIndexPath.section, dueDatePickerCellIndexPath.row - 1):
      if isDueDatePickerShown { // close picker if picker was already open
        isDueDatePickerShown = false
        isDueDatePressed = false
      } else if isDueDatePressed {
        isDueDatePickerShown = false
        isDueDatePressed = false
      } else if isDueTimePickerShown { // if dueTimePicker was open, close it and open dueDatePicker
        isDueDatePressed = true
        isDueTimePickerShown = false
        isDueDatePickerShown = false
        isRepeatShown = false
        toDoItemText.resignFirstResponder()
      } else if isRepeatShown { // if repeatPicker was open, close it and open dueDatePicker
        isDueDatePressed = true
        isDueDatePickerShown = false
        isDueTimePickerShown = false
        isRepeatShown = false
        toDoItemText.resignFirstResponder()
      } else { // if nothing open, open dueDatePicker
        isDueDatePressed = true
        toDoItemText.resignFirstResponder()
      }
      
      tableView.beginUpdates()
      tableView.endUpdates()
      
    case (dueTimePickerCellIndexPath.section, dueTimePickerCellIndexPath.row - 1):
      if dueDateField.text != "" {
        if isDueTimePickerShown {
          isDueTimePickerShown = false
        } else if isDueDatePressed {
          isDueDatePressed = false
          isDueDatePickerShown = false
          isDueTimePickerShown = true
          isRepeatShown = false
          toDoItemText.resignFirstResponder()
        }else if isDueDatePickerShown {
          isDueDatePressed = false
          isDueDatePickerShown = false
          isDueTimePickerShown = true
          isRepeatShown = false
          toDoItemText.resignFirstResponder()
        } else if isRepeatShown {
          isDueDatePressed = false
          isDueTimePickerShown = true
          isDueDatePickerShown = false
          isRepeatShown = false
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
        if isRepeatShown {
          isRepeatShown = false
        } else if isDueDatePressed {
          isDueDatePressed = false
          isDueTimePickerShown = false
          isDueDatePickerShown = false
          isRepeatShown = true
          toDoItemText.resignFirstResponder()
        }else if isDueTimePickerShown {
          isDueDatePressed = false
          isDueTimePickerShown = false
          isDueDatePickerShown = false
          isRepeatShown = true
          toDoItemText.resignFirstResponder()
        } else if isDueDatePickerShown {
          isDueDatePressed = false
          isDueDatePickerShown = false
          isDueTimePickerShown = false
          isRepeatShown = true
          toDoItemText.resignFirstResponder()
        } else {
          isRepeatShown = true
          toDoItemText.resignFirstResponder()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
      }
    case (1, 10):
      let cell = tableView.cellForRow(at: indexPath)
      cell?.selectionStyle = UITableViewCellSelectionStyle.none
    default:
      break
    }
  }
  
  // MARK: segue
  @IBAction func unwindWithContex(sender: UIStoryboardSegue) {
    contextField.text = controller.updateContextField()
    if contextField.text == "" {
      parentField.text = ""
    }
    // update height for parent row
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  @IBAction func unwindWithNotes(sender: UIStoryboardSegue) {
//    notesButton.backgroundColor = themeController.headerBackgroundColor
//    infoButton.backgroundColor = themeController.backgroundColor
  }
  
  @IBAction func unwindWithParent(sender: UIStoryboardSegue) {
    parentField.text = controller.updateParentField()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.noteSegue {
      let controller = segue.destination as! NotesViewController
      self.controller.delegate = controller.controller
      self.controller.setNotes()
    } else if segue.identifier == "ParentSegue" {
      let controller = segue.destination as! ParentViewController
      controller.controller = ParentController(context: contextField.text ?? "")
    } else if segue.identifier == "UnwindFromToDo" {
      let controller = segue.destination as! EventViewController
      controller.controller.toDoModelController = self.controller.toDoModelController
    }
  }
  
}

