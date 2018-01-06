//
//  ViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

protocol InformEventTableDelegate: class {
  func sendCalendarPressInformation(_ Date: String)
  func sendNewReminderDueDateAfterDropSession(_ newDate: String)
}

protocol PassToDoModelToMainDelegate: class {
  func returnToDoModel(_ controller: RemindersController)
}


class ViewController: UIViewController, InformEventTableOfCalendarPressDelegate {
  
  func reminderDroppedOnCalendarDate(_ newDate: String) {
    delegate?.sendNewReminderDueDateAfterDropSession(newDate)
  }
  
  weak var passToDoModelDelegate: PassToDoModelToMainDelegate?
  
  @IBOutlet weak var calendarContainer: UIView!
  var remindersController: RemindersController!
  @IBOutlet weak var eventContainer: UIView!
  weak var delegate: InformEventTableDelegate?
  var themeController = ThemeController()
  var buttonPressedBool = false // prevent user from pressing additembutton during transitions
//
//  var eventViewcontroller: EventViewController!
//  var calendarViewController: CalendarViewController?
  
  override func viewWillDisappear(_ animated: Bool) {
    if isMovingFromParentViewController {
      passToDoModelDelegate?.returnToDoModel(remindersController)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    themeController = ThemeController()
    navigationController?.navigationBar.barTintColor = themeController.navigationBarColor
    navigationController?.navigationBar.tintColor = .white
    view.backgroundColor = themeController.backgroundColor
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // delegate from calendarcontroller to viewcontroller
  func calendarDayPressed(_ Date: String) {
    delegate?.sendCalendarPressInformation(Date) // send data to delegate to eventcontroller
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case segueIdentifiers.calendarSegue?:
      let controller = segue.destination as! CalendarViewController
      controller.delegate = self // A receives notifications from B
    case segueIdentifiers.eventSegue?:
      let destination = segue.destination as! EventViewController
      destination.controller = EventController(controller: remindersController)
      self.delegate = destination as InformEventTableDelegate // sending information from A to C
    default:
      return
    }
  }
  
}