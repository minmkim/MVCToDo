//
//  EventDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension EventViewController: UITableViewDelegate, UITableViewDataSource {

  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    let numberOfSections = controller.numberOfSections()
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rowsPerSection = controller.rowsPerSection(section: section)
    return rowsPerSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
    cell.toDoItem = controller.cellLabelStrings(indexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 17))
    let label = UILabel()
    label.textColor = .lightGray
    label.text = controller.headerTitleOfSections(index: section)
    returnedView.backgroundColor = .white
    label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    returnedView.addSubview(label)
    label.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 14).isActive = true
    label.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 17).isActive = true
    returnedView.addSubview(label)
    return returnedView
  }
  
}
