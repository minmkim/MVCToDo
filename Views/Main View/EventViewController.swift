//
//  EventViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit


class EventViewController: UIViewController, InformEventTableDelegate {
  
  func sendCalendarPressInformation(_ Date: String) {
    let index = controller.scrollToCalendarPressDate(Date)
    let newIndexPath = IndexPath(row:0, section: index)
    eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
  }
  

  @IBOutlet weak var eventTableView: UITableView!
  let controller = EventController()
  
  var calendarPressDate: Int? {
    didSet {
      guard let selectedSection = controller.calendarPressIndex else {return}
      print("here")
      let indexPath = IndexPath(row: 0, section: selectedSection)
      eventTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    eventTableView.delegate = self
    eventTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.editToDoSegue {
      let controller = segue.destination as! AddItemTableViewController
      print("segue")
      controller.controller.title = "Edit To Do"
      
      if let indexPath = eventTableView.indexPath(for: sender as! EventTableViewCell) {
        let cell = eventTableView.cellForRow(at: indexPath) as! EventTableViewCell
        controller.controller.toDoItem = cell.toDoItem
      }
    }
  }

}
