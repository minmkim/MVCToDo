//
//  MainViewViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class MainViewViewController: UIViewController {
  
  @IBOutlet weak var mainViewTable: UITableView!
  var controller = MainViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainViewTable.delegate = self
    mainViewTable.dataSource = self
    navigationItem.title = "Due Life"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .white
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    print("did appear")
    DispatchQueue.main.async() { // update contexts
      self.controller = MainViewController()
      self.mainViewTable.reloadData()
    }
  }
  
  //this does not work, sends wrote title
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ContextItemSegue" {
      let destination = segue.destination as! ContextItemViewController
      let title = controller.returnContextString(controller.selectedContextIndex)
      print(title)
      destination.navigationItem.title = title
      destination.controller.title = title
      print(destination.controller)
    }
  }
  
}
