//
//  TodayViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

protocol ReturnRemindersControllerFromTodayDelegate: class {
  func delegateRemindersController(_ remindersController: RemindersController)
}

class TodayViewController: UIViewController {

  weak var returnRemindersControllerDelegate: ReturnRemindersControllerFromTodayDelegate?
  @IBOutlet weak var addItemButton: UIButton!
  var todayController: TodayController!
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var todayTableView: UITableView!
  var shownIndexes : [IndexPath] = []
  var isDarkTheme = false
  
  @IBAction func addItemButtonPressed(_ sender: Any) {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    UIView.animate(withDuration: 0.2, animations: {
      let rotateTransform = CGAffineTransform(rotationAngle: .pi)
      self.addItemButton.transform = rotateTransform
    }) { (_) in
      
      self.addItemButton.transform = CGAffineTransform.identity
    }
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: segueIdentifiers.addFromTodaySegue, sender: self)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    todayController.delegate = self
    todayTableView.delegate = self
    todayTableView.dataSource = self
    if isDarkTheme {
      footerView.backgroundColor = darkTheme.backgroundColor
      view.backgroundColor = darkTheme.backgroundColor
      todayTableView.backgroundColor = darkTheme.backgroundColor
      addItemButton.setImage(UIImage(named: darkTheme.addCircle), for: .normal)
    } else {
      footerView.backgroundColor = lightTheme.backgroundColor
      view.backgroundColor = lightTheme.backgroundColor
      todayTableView.backgroundColor = lightTheme.backgroundColor
      addItemButton.setImage(UIImage(named: lightTheme.addCircle), for: .normal)
    }
    
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
    }
  
  override func viewWillAppear(_ animated: Bool) {
    isDarkTheme = UserDefaults.standard.bool(forKey: "DarkTheme")
    print(isDarkTheme)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if isMovingFromParentViewController {
      returnRemindersControllerDelegate?.delegateRemindersController(todayController.remindersController)
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func unwindToTodayView(sender: UIStoryboardSegue) {
    todayController.delegate = self
    todayTableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.editFromTodaySegue {
      let destination = segue.destination as! AddItemTableViewController
      guard let reminder = todayController.returnEditingToDo() else {return}
      destination.controller = AddEditToDoController(ItemToEdit: reminder)
      destination.controller.segueIdentity = segueIdentifiers.editFromTodaySegue
    } else if segue.identifier == segueIdentifiers.addFromTodaySegue {
      let navigation: UINavigationController = segue.destination as! UINavigationController
      var vc = AddItemTableViewController.init()
      vc = navigation.viewControllers[0] as! AddItemTableViewController
      vc.controller = AddEditToDoController()
      vc.controller.todayDate = true
      vc.controller.segueIdentity = segueIdentifiers.addFromTodaySegue
      vc.navigationController?.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
      vc.navigationController?.navigationBar.tintColor = .white
    }
  }
  
}

extension TodayViewController: TodayTableViewDelegate {
  func deleteRows(_ index: IndexPath) {
    print("delete row")
    todayTableView.deleteRows(at: [index], with: .fade)
  }
  func deleteSection(_ index: IndexPath) {
    print("delete section")
    todayTableView.deleteSections([index.section], with: .fade)
  }
  func beginUpdate() {
    print("begin update")
    todayTableView.beginUpdates()
  }
  func endUpdate() {
    print("end update")
    todayTableView.endUpdates()
  }
  func updateTableView() {
    print("update table")
    todayTableView.reloadData()
  }
  func insertRow(_ indexPath: IndexPath) {
    print("insert row")
    todayTableView.insertRows(at: [indexPath], with: .fade)
  }
  func insertSection(_ indexPath: IndexPath) {
    todayTableView.insertSections([indexPath.section], with: .fade)
  }
}
