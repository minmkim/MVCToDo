//
//  PickerViewExtension.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/23/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension AddItemTableViewController: UIPickerViewDelegate {
  
  // setup date and time picker if coming from editsegue
  func setDatePickerDate() {
    dueDatePicker.datePickerMode = UIDatePickerMode.date
    dueDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    
    if dueDateField.text != "" {
      let date = Helper.formatStringToDate(date: dueDateField.text!, format: dateAndTime.monthDateYear)
      dueDatePicker.setDate(date, animated: true)
    }
  }
  
  func setTimePickerTime() {
    dueTimePicker.addTarget(self, action: #selector(timePickerValueChanged), for: UIControlEvents.valueChanged)
    
    dueTimePicker.datePickerMode = UIDatePickerMode.time
    if dueTimeField.text != "" {
      let time = Helper.formatStringToDate(date: dueTimeField.text!, format: dateAndTime.hourMinute)
      dueTimePicker.setDate(time, animated: true)
    }
  }
  
  // update time and date field when picker changes
  @objc func datePickerValueChanged(sender:UIDatePicker) {
    dueDateField.text = Helper.formatDateToString(date: sender.date, format: dateAndTime.monthDateYear)
  }
  
  @objc func timePickerValueChanged(sender:UIDatePicker) {
    let time = Helper.formatDateToString(date: sender.date, format: dateAndTime.hourMinute)
    dueTimeField.text = time
    alarmTime.text = time
    controller.endRepeatDate = sender.date
    notificationSwitch.isEnabled = true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == ReminderTitleField  { // Switch focus to other text field
      ReminderTitleField.resignFirstResponder()
    }
    return true
  }
  
}
