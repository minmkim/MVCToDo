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
  var todayController = TodayController()
  var themeController = ThemeController()
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var todayTableView: UITableView!
  
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
    todayTableView.backgroundColor = themeController.backgroundColor
    navigationController?.navigationBar.barTintColor = themeController.mainThemeColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func unwindToTodayView(sender: UIStoryboardSegue) {
    todayController = TodayController()
    todayTableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.editFromTodaySegue {
      let destination = segue.destination as! AddItemTableViewController
      guard let toDoItem = todayController.returnEditingToDo() else {return}
      destination.controller = AddEditToDoController(ItemToEdit: toDoItem)
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
}
