//
//  PickerViewExtension.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/23/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension AddItemTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
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
    
    controller.numberRepeatInt = Int(controller.numberRepeat[numberOfRepeat]) ?? 0
    controller.cycleRepeatString = controller.repeatingNotifications[cycleRepeat]  //["Days", "Weeks", "Months"]
    
    if controller.numberRepeatInt == 1 {
      switch controller.cycleRepeatString {
      case "Days":
        repeatingField.text = "Every Day"
      case "Weeks":
        repeatingField.text = "Every Week"
      case "Months":
        repeatingField.text = "Every Month"
      default:
        print("error in selecting picker row")
      }
    } else {
      repeatingField.text = ("Every \(controller.numberRepeat[numberOfRepeat]) \(controller.repeatingNotifications[cycleRepeat])")
    }
  }
  
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == toDoItemText  { // Switch focus to other text field
      toDoItemText.resignFirstResponder()
    }
    return true
  }
  
  //MARK: Stepper
  func updateNagNumber() {
    switch nagStepper.value {
    case 0:
      nagLabel.text = "None"
    //   controller.nagInt = nil
    case 1:
      nagLabel.text = "Every Minute"
    //   controller.nagInt = Int(nagStepper.value)
    default:
      nagLabel.text = "Every \(Int(nagStepper.value)) Minutes"
      //   controller.nagInt = Int(nagStepper.value)
    }
  }
  
}
