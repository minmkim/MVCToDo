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
}

class ViewController: UIViewController, InformEventTableOfCalendarPressDelegate {
  
  @IBOutlet weak var addItemButton: UIButton!
  weak var delegate: InformEventTableDelegate?
  var buttonPressedBool = false // prevent user from pressing additembutton during transitions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // delegate from calendarcontroller to viewcontroller
  func calendarDayPressed(_ Date: String) {
    delegate?.sendCalendarPressInformation(Date) // send data to delegate to eventcontroller
  }
  
  @objc func newToDoButtonPressed(_ sender: UIButton) {
    print("here1")
    performSegue(withIdentifier: "AddToDoSegue", sender: self)
  }
  
  @objc func newCalendarButtonPress(_ sender: UIButton) {
    print("here2")
    performSegue(withIdentifier: "AddCalendarSegue", sender: self)
  }

  @IBAction func buttonPress(_ sender: Any) {
    if !buttonPressedBool {
      buttonPressedBool = true
      let newView = UIView()
      let newEvent = UIButton()
      let newToDo = UIButton()
      let originFrame = addItemButton.frame
      
      newView.frame = CGRect(x: originFrame.minX, y: originFrame.minY, width: 10, height: 10)
      view.addSubview(newView)
      newView.backgroundColor = .clear
      newView.layer.cornerRadius = 10
      
      newEvent.frame = CGRect(x: originFrame.minX + 5, y: originFrame.minY + 5, width: 20, height: 20)
      addItemButton.center = newEvent.center
      newEvent.setImage(UIImage(named: "CalendarIcon"), for: .normal)
      newEvent.addTarget(self, action: #selector(newCalendarButtonPress(_:)), for: .touchUpInside)
      view.addSubview(newEvent)
      
      newToDo.frame = CGRect(x: originFrame.minX + 5, y: originFrame.minY - 5, width: 20, height: 20)
      addItemButton.center = newToDo.center
      newToDo.setImage(UIImage(named: "ToDoIcon"), for: .normal)
      newToDo.addTarget(self, action: #selector(newToDoButtonPressed(_:)), for: .touchUpInside)
      view.addSubview(newToDo)
      
      
      view.bringSubview(toFront: addItemButton)
      
      UIView.animate(withDuration: 0.3, animations: {
        let rotateTransform = CGAffineTransform(rotationAngle: .pi)
        self.addItemButton.transform = rotateTransform
        newView.backgroundColor = UIColor(red: 0.604, green: 0.759, blue: 1.0, alpha: 0.6)
        newView.frame = CGRect(x: (self.view.frame.maxX/2.0), y: originFrame.minY, width: (self.view.frame.maxX/2.0) - 58, height: 40)
        print((self.view.frame.maxX/2.0))
        print((self.view.frame.maxX/2.0) - 58)
        newToDo.isEnabled = true
        newToDo.frame = CGRect(x: originFrame.minX - 120, y: originFrame.minY, width: 40, height: 40)
        self.view.bringSubview(toFront: newToDo)
        print((x: originFrame.minX - 120))
        print(originFrame.minX - 65.5)
      }) { (_) in
        UIView.animate(withDuration: 0.3, delay: 0.15, animations: {
          newEvent.isEnabled = true
          newEvent.frame = CGRect(x: originFrame.minX - 65.5, y: originFrame.minY, width: 40, height: 40)
          self.view.bringSubview(toFront: newEvent)
          self.addItemButton.transform = CGAffineTransform.identity
        }) { (_) in
          UIView.animate(withDuration: 3.0, delay: 0.0, animations: {
            let sizeTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            newView.transform = sizeTransform
          }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
              let rotateTransform = CGAffineTransform(rotationAngle: .pi)
              print("here3")
              self.addItemButton.transform = rotateTransform
              self.addItemButton.transform = CGAffineTransform.identity
              newView.frame = CGRect(x: originFrame.minX, y: originFrame.minY, width: 1, height: 1)
              newToDo.frame = CGRect(x: originFrame.minX, y: originFrame.minY, width: 1, height: 1)
              newEvent.frame = CGRect(x: originFrame.minX, y: originFrame.minY, width: 10, height: 1)
              newView.backgroundColor = .clear
              newToDo.isHidden = true
              newEvent.isHidden = true
              newToDo.isEnabled = false
              newEvent.isEnabled = false
              self.buttonPressedBool = false
            })
          }
        }
      }
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
      vc.controller.title = "Add To Do"
    //  let _ = segue.destination as! AddItemTableViewController
//    case segueIdentifiers.editToDoSegue?:
//      let controller = segue.destination as! AddItemTableViewController
//      controller.controller.title = "Edit To Do"
    default:
      return
    }
  }
  
  
  

}

