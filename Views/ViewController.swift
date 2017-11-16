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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func calendarDayPressed(_ Date: String) {
    delegate?.sendCalendarPressInformation(Date)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CalendarSegue"{
      let controller = segue.destination as! CalendarViewController
      controller.delegate = self // A receives notifications from B
    } else if segue.identifier == "EventSegue"{
      let controller = segue.destination as! EventViewController
      self.delegate = controller as InformEventTableDelegate // sending information from A to C
    }
  }
  



  @IBAction func buttonPress(_ sender: Any) {
    print("hi")
  }
  
  
}


