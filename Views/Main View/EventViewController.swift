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
    if index != -1 {
      let newIndexPath = IndexPath(row:0, section: index)
      eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
    }
  }
  
  @IBOutlet weak var eventTableView: UITableView!
  var controller = EventController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    eventTableView.delegate = self
    eventTableView.dataSource = self
    let index = controller.scrollToCalendarPressDate(controller.formatDateToString(date: Date(), format: dateAndTime.monthDateYear))
    if index != -1 {
      let newIndexPath = IndexPath(row:0, section: index)
      eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
    }
    controller.updateEventTableView = { [unowned self] () in
      DispatchQueue.main.async {
        self.eventTableView.reloadData()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.editToDoSegue {
      guard let indexPath = eventTableView.indexPath(for: sender as! EventTableViewCell) else {return}
      let cell = eventTableView.cellForRow(at: indexPath) as! EventTableViewCell
      let controller = segue.destination as! AddItemTableViewController
      controller.controller = AddEditToDoController(ItemToEdit: cell.toDoItem!)
    }
  }
  
  @IBAction func unwindFromAddToDo(sender: UIStoryboardSegue) {
    controller.setToDoDates()
    eventTableView.reloadData()
  }
  
}
