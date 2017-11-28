//
//  ContextItemViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ContextItemViewController: UIViewController {

  @IBOutlet weak var contextItemTableView: UITableView!
  let controller = ContextItemController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contextItemTableView.delegate = self
    contextItemTableView.dataSource = self
    let color = controller.returnNavigationBarColor()
    navigationController?.navigationBar.barTintColor = color
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
