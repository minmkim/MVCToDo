//
//  EventViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit


class EventViewController: UIViewController, InformEventTableDelegate, UpdateTableViewDelegate {
  
  // MARK: Delegate functions
  // UpdateTableViewDelegate functions
  func insertRow(_ indexPath: IndexPath) {
    print("inserted row")
    eventTableView.insertRows(at: [indexPath], with: .fade)
  }
  
  func deleteRow(_ indexPath: IndexPath) {
    print("deleted row")
    eventTableView.deleteRows(at: [indexPath], with: .fade)
  }
  
  func insertSection(_ indexPath: IndexPath) {
    print("inserted section")
    eventTableView.insertSections([indexPath.section], with: .fade)
  }
  
  func deleteSection(_ indexPath: IndexPath) {
    print("deleted section")
    eventTableView.deleteSections([indexPath.section], with: .fade)
  }
  
  func updateTableView() {
    print("updated")
    eventTableView.reloadData()
  }
  
  func moveRowAt(originIndex: IndexPath, destinationIndex: IndexPath) {
    eventTableView.moveRow(at: originIndex, to: destinationIndex)
  }
  
  func beginUpdates() {
    print("begin")
    eventTableView.beginUpdates()
  }
  
  func endUpdates() {
    print("end")
    eventTableView.endUpdates()
  }
  
  func updateCell(originIndex: IndexPath, updatedToDo: ToDo) {
    guard let cell = eventTableView.cellForRow(at: originIndex) as? EventTableViewCell else {return}
    cell.toDoItem = updatedToDo
  }

  // update duedate after drag and drop
  func sendNewToDoDueDateAfterDropSession(_ newDate: String) {
    DispatchQueue.main.async() {
      self.controller.updateDueDate(newDate)
    }
  }
  
  func sendCalendarPressInformation(_ Date: String) {
    let index = controller.scrollToCalendarPressDate(Date)
    if index != -1 {
      let newIndexPath = IndexPath(row:0, section: index)
      if eventTableView.numberOfRows(inSection: index) == 0 && eventTableView.numberOfRows(inSection: (index + 1)) != 0 {
        let indexPath = IndexPath(row:0, section: index + 1)
        eventTableView.scrollToRow(at: indexPath, at: .top, animated: true)
      } else if eventTableView.numberOfRows(inSection: index) == 0 && eventTableView.numberOfRows(inSection: (index - 1)) != 0 {
        let indexPath = IndexPath(row:0, section: index - 1)
        eventTableView.scrollToRow(at: indexPath, at: .top, animated: true)
      } else {
      eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
      }
    }
  }
  // end delegate functions
  
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var eventTableView: UITableView!
  var didInitialScroll = false
  var controller = EventController()
  var themeController = ThemeController()
  var shownIndexes : [IndexPath] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    controller.delegate = self
    eventTableView.delegate = self
    eventTableView.dataSource = self
    eventTableView.dragDelegate = self
    eventTableView.dragInteractionEnabled = true
    eventTableView.dropDelegate = self
    self.eventTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    themeController = ThemeController()
    eventTableView.reloadData()
    eventTableView.backgroundColor = themeController.backgroundColor
    footerView.backgroundColor = themeController.backgroundColor
  }
  
  override func viewDidLayoutSubviews() {
    if didInitialScroll == false {
      didInitialScroll = true
      let index = controller.scrollToCalendarPressDate(controller.formatDateToString(date: Date(), format: dateAndTime.monthDateYear))
      print("index: \(index)")
      if index != -1 {
        let newIndexPath = IndexPath(row:0, section: index)
        print(newIndexPath)
        eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
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
