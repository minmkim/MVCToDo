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
  func sendNewToDoDueDateAfterDropSession(_ newDate: String)
}

protocol PassToDoModelToMainDelegate: class {
  func returnToDoModel(_ controller: ToDoModelController)
}


class ViewController: UIViewController, InformEventTableOfCalendarPressDelegate {
  
  func toDoDroppedOnCalendarDate(_ newDate: String) {
    delegate?.sendNewToDoDueDateAfterDropSession(newDate)
  }
  
  weak var passToDoModelDelegate: PassToDoModelToMainDelegate?
  
  @IBOutlet weak var calendarContainer: UIView!
  var toDoModelController: ToDoModelController!
  @IBOutlet weak var eventContainer: UIView!
  weak var delegate: InformEventTableDelegate?
  var themeController = ThemeController()
  var buttonPressedBool = false // prevent user from pressing additembutton during transitions
//
//  var eventViewcontroller: EventViewController!
//  var calendarViewController: CalendarViewController?
  
  override func viewWillDisappear(_ animated: Bool) {
    if isMovingFromParentViewController {
      passToDoModelDelegate?.returnToDoModel(toDoModelController)
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
  
  private func addContentController(_ child: UIViewController, to container: UIView) {
    addChildViewController(child)
    container.addSubview(child.view)
    child.didMove(toParentViewController: self)
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
      
      self.delegate = destination as InformEventTableDelegate // sending information from A to C
      destination.controller.toDoModelController = toDoModelController
      destination.controller.toDoModelController.updateView()
      toDoModelController = nil

    default:
      return
    }
  }
  
  private func buildFromStoryboard<T>(_ name: String) -> T {
    print("adding2")
    let storyboard = UIStoryboard(name: name, bundle: nil)
    let identifier = String(describing: T.self)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("Missing \(identifier) in Storyboard")
    }
    print("adding3")
    return viewController
  }
  
}


