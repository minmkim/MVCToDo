//
//  MainViewTableDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension MainViewViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 1
    case 2:
      return controller.numberOfContext()
    case 3:
      return 1
    default:
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = mainViewTable.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath)
      return cell
    case 1:
      let cell = mainViewTable.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
      cell.backgroundColor = .groupTableViewBackground
      return cell
    case 2:
      let cell = mainViewTable.dequeueReusableCell(withIdentifier: "ContextCell", for: indexPath) as! MainDisplayTableViewCell
      
      cell.descriptionLabel.text = controller.returnContextString(indexPath.row)
      cell.numberOfContext.text = controller.returnCellNumberOfContextString(indexPath.row)
      return cell
    default:
      let cell = mainViewTable.dequeueReusableCell(withIdentifier: "AddContextCell", for: indexPath)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    mainViewTable.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 0 {
      performSegue(withIdentifier: "AllSegue", sender: self)
    } else if indexPath.section == 2 {
      controller.setIndexPathForContextSelect(indexPath.row)
      performSegue(withIdentifier: "ContextItemSegue", sender: self)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 {
      return 28.0
    } else {
      return 50.0
    }
  }
  
  
}
