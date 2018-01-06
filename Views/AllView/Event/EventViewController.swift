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
    DispatchQueue.main.async {
      self.eventTableView.reloadData()
    }
  }
  
  func moveRowAt(originIndex: IndexPath, destinationIndex: IndexPath) {
    print("move row")
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
  
  func updateCell(originIndex: IndexPath, updatedReminder: Reminder) {
    print("update cell")
    guard let cell = eventTableView.cellForRow(at: originIndex) as? EventTableViewCell else {return}
    cell.reminder = updatedReminder
    cell.isDarkTheme = themeController.isDarkTheme
  }

  // update duedate after drag and drop
  func sendNewReminderDueDateAfterDropSession(_ newDate: String) {
    print("update due date")
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
  @IBOutlet weak var addItemButton: UIButton!
  var didInitialScroll = false
  var controller: EventController!
  var themeController = ThemeController()
  var shownIndexes : [IndexPath] = []
  
  @IBAction func buttonPress(_ sender: Any) {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    UIView.animate(withDuration: 0.2, animations: {
      let rotateTransform = CGAffineTransform(rotationAngle: .pi)
      self.addItemButton.transform = rotateTransform
    }) { [unowned self] (_) in
      self.addItemButton.transform = CGAffineTransform.identity
    }
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: segueIdentifiers.addToDoSegue, sender: self)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    controller.delegate = self
    eventTableView.delegate = self
    eventTableView.dataSource = self
    eventTableView.dragDelegate = self
    eventTableView.dragInteractionEnabled = true
    eventTableView.dropDelegate = self
    self.eventTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.6
    addItemButton.layer.shadowColor = UIColor.black.cgColor
    eventTableView.backgroundColor = themeController.backgroundColor
    footerView.backgroundColor = themeController.backgroundColor
    addItemButton.setImage(UIImage(named: themeController.addCircle), for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    themeController.checkTheme()
    if eventTableView.backgroundColor != themeController.backgroundColor {
      eventTableView.backgroundColor = themeController.backgroundColor
      footerView.backgroundColor = themeController.backgroundColor
      addItemButton.setImage(UIImage(named: themeController.addCircle), for: .normal)
      eventTableView.reloadData()
    }
  }
  
  // need to move this to after completion handler of reminders load
  override func viewDidLayoutSubviews() {
//    if didInitialScroll == false {
//      didInitialScroll = true
//      let index = controller.scrollToCalendarPressDate(controller.formatDateToString(date: Date(), format: dateAndTime.monthDateYear))
//      print("index: \(index)")
//      if index != -1 {
//        let newIndexPath = IndexPath(row:0, section: index)
//        print(newIndexPath)
//        eventTableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
//      }
//    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.editToDoSegue {
      guard let indexPath = eventTableView.indexPath(for: sender as! EventTableViewCell) else {return}
      let cell = eventTableView.cellForRow(at: indexPath) as! EventTableViewCell
      let destination = segue.destination as! AddItemTableViewController
      destination.controller = AddEditToDoController(ItemToEdit: cell.reminder)
      if themeController.isDarkTheme {
        destination.navigationController?.navigationBar.tintColor = .black
      }
    } else if segue.identifier == segueIdentifiers.addToDoSegue {
      let navigation: UINavigationController = segue.destination as! UINavigationController
      var vc = AddItemTableViewController.init()
      vc = navigation.viewControllers[0] as! AddItemTableViewController
      vc.controller = AddEditToDoController()
      vc.controller.segueIdentity = segueIdentifiers.addToDoSegue
      if themeController.isDarkTheme {
        vc.navigationController?.navigationBar.tintColor = .black
      } else {
        vc.navigationController?.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
      }
    }
  }
  
  @IBAction func unwindFromAddToDo(sender: UIStoryboardSegue) {
  }
  
}
