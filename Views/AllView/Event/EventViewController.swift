//
//  EventViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit


class EventViewController: UIViewController, InformEventTableDelegate {
  
  // MARK: Delegate functions
  func sendNewToDoDueDateAfterDropSession(_ newDate: String) {
    DispatchQueue.main.async() {
      self.eventTableView.beginUpdates()
      let isDueDateDifferent = self.controller.updateDueDateForToDoItem(newDate)
      guard let originalIndexPath = self.controller.dragIndexPathOrigin else {return}
      if isDueDateDifferent { //need to check origin before updating controller
        if self.controller.checkForItemsInDate(section: originalIndexPath.section) {
          print("deleting section")
          self.eventTableView.deleteSections([originalIndexPath.section], with: .fade)
        }
        print("here2")
        self.controller.setToDoDates()
        self.eventTableView.deleteRows(at: [originalIndexPath], with: .fade)
        let indexPath = self.controller.calculateIndexPath(newDate)
        
        if self.controller.rowsPerSection(section: indexPath.section) == 1 {
          print("inserting section")
          self.eventTableView.insertSections([indexPath.section], with: .fade)
        }
        
        self.eventTableView.insertRows(at: [indexPath], with: .fade)
        print("here1")
        
      }
      self.eventTableView.endUpdates()
    }
  }
  
  func sendCalendarPressInformation(_ Date: String) {
    let index = controller.scrollToCalendarPressDate(Date)
    if index != -1 {
      let newIndexPath = IndexPath(row:0, section: index)
      eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
    }
  }
  // end delegate functions
  
  @IBOutlet weak var eventTableView: UITableView!
  var controller = EventController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    eventTableView.delegate = self
    eventTableView.dataSource = self
    eventTableView.dragDelegate = self
    eventTableView.dragInteractionEnabled = true
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
    self.eventTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    
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
