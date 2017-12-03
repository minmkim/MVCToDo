//
//  TodayViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

  
  var todayController = TodayController()
  var themeController = ThemeController()
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var todayTableView: UITableView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    todayTableView.delegate = self
    todayTableView.dataSource = self
      footerView.backgroundColor = themeController.backgroundColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
