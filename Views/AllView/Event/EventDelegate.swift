//
//  EventDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox.AudioServices

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
    cell.checkmarkButton.setTitle(cell.toDoItem?.cloudRecordID, for: .normal)
    cell.checkmarkButton.addTarget(self,action:#selector(checkmarkButtonPress), for:.touchUpInside)
    cell.backgroundColor = themeController.backgroundColor
    cell.toDoLabel.textColor = themeController.mainTextColor
    if cell.toDoItem?.checked ?? false {
      cell.checkmarkButton.setImage(UIImage(named: themeController.checkedCheckmarkIcon), for: .normal)
    } else {
      cell.checkmarkButton.setImage(UIImage(named: themeController.uncheckedCheckmarkIcon), for: .normal)
    }
    return cell
  }
  
  @objc func checkmarkButtonPress(sender: UIButton) {
    let generator = UISelectionFeedbackGenerator()
    let peek = SystemSoundID(1519)
    guard let cellID = sender.title(for: .normal) else {return}
    let image = controller.checkmarkButtonPressedController(cellID)
    generator.prepare()
    AudioServicesPlaySystemSound(peek)
    generator.selectionChanged()
    sender.setImage(UIImage(named: image), for: .normal)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 17))
    let label = UILabel()
    returnedView.addSubview(label)
    returnedView.backgroundColor = themeController.headerBackgroundColor
    label.textColor = .lightGray
    label.text = controller.headerTitleOfSections(index: section)
    label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 14).isActive = true
    label.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 17).isActive = true
    
    if controller.checkIfToday(label.text ?? "") {
      let todayLabel = UILabel()
      returnedView.addSubview(todayLabel)
      todayLabel.textColor = .red
      todayLabel.text = "Today"
      todayLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
      todayLabel.translatesAutoresizingMaskIntoConstraints = false
      todayLabel.trailingAnchor.constraint(equalTo: returnedView.trailingAnchor, constant: -14).isActive = true
      todayLabel.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true
      todayLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
    return returnedView
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let cell = eventTableView.cellForRow(at: indexPath) as! EventTableViewCell
      guard let cloudID = cell.toDoItem?.cloudRecordID else {return}
      eventTableView.beginUpdates()
      controller.deleteItem(ID: cloudID, indexPath: indexPath)
      eventTableView.endUpdates()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    eventTableView.deselectRow(at: indexPath, animated: true)
  }
  
}
