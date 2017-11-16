//
//  EventViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit


class EventViewController: UIViewController {

  @IBOutlet weak var eventTableView: UITableView!
  let controller = EventController()
  
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
    


}
