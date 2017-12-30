//
//  TodayViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

  
  @IBOutlet weak var addItemButton: UIButton!
  var todayController: TodayController!
  var themeController = ThemeController()
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var todayTableView: UITableView!
  var shownIndexes : [IndexPath] = []
  
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
      footerView.backgroundColor = themeController.backgroundColor
    view.backgroundColor = themeController.backgroundColor
    todayTableView.backgroundColor = themeController.backgroundColor
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
    addItemButton.setImage(UIImage(named: themeController.addCircle) , for: .normal)
        // Do any additional setup after loading the view.
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
