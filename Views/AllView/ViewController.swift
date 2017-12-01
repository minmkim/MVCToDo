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

class ViewController: UIViewController, InformEventTableOfCalendarPressDelegate {
  
  func toDoDroppedOnCalendarDate(_ newDate: String) {
    delegate?.sendNewToDoDueDateAfterDropSession(newDate)
  }

  
  @IBOutlet weak var addItemButton: UIButton!
  weak var delegate: InformEventTableDelegate?
  var themeController = ThemeController()
  var buttonPressedBool = false // prevent user from pressing additembutton during transitions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    themeController = ThemeController()
    navigationController?.navigationBar.barTintColor = themeController.navigationBarColor
    navigationController?.navigationBar.tintColor = .white
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // delegate from calendarcontroller to viewcontroller
  func calendarDayPressed(_ Date: String) {
    delegate?.sendCalendarPressInformation(Date) // send data to delegate to eventcontroller
  }
  
  @IBAction func buttonPress(_ sender: Any) {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    UIView.animate(withDuration: 0.2, animations: {
      let rotateTransform = CGAffineTransform(rotationAngle: .pi)
      self.addItemButton.transform = rotateTransform
    }) { (_) in
      
      self.addItemButton.transform = CGAffineTransform.identity
    }
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: segueIdentifiers.addToDoSegue, sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case segueIdentifiers.calendarSegue?:
      let controller = segue.destination as! CalendarViewController
      controller.delegate = self // A receives notifications from B
    case segueIdentifiers.eventSegue?:
      let controller = segue.destination as! EventViewController
      self.delegate = controller as InformEventTableDelegate // sending information from A to C
    case segueIdentifiers.addToDoSegue?:
      let navigation: UINavigationController = segue.destination as! UINavigationController
      var vc = AddItemTableViewController.init()
      vc = navigation.viewControllers[0] as! AddItemTableViewController
      vc.controller = AddEditToDoController()
      vc.navigationController?.navigationBar.barTintColor = themeController.navigationBarColor
    default:
      return
    }
  }
  
  
  
}

