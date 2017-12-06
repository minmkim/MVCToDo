//
//  ContextItemTableViewDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox.AudioServices

extension ContextItemViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    let numberOfSections = controller.returnNumberOfSections()
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return controller.returnNumberOfRowsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = contextItemTableView.dequeueReusableCell(withIdentifier: "ContextItem", for: indexPath) as! ContextItemTableViewCell
    let toDoItem = controller.returnToDoItemForCell(indexPath)
    if toDoItem.contextSection != "" {
      cell.layoutMargins = UIEdgeInsetsMake(0, 30, 0, 0)
    } else {
      cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    cell.toDoItem = toDoItem
    cell.toDoItemLabel.textColor = themeController.mainTextColor
    cell.checkMarkButton.setTitle(cell.toDoItem?.cloudRecordID, for: .normal)
    cell.checkMarkButton.addTarget(self,action:#selector(checkmarkButtonPress), for:.touchUpInside)
    if cell.toDoItem?.checked ?? false {
      cell.checkMarkButton.setImage(UIImage(named: themeController.checkedCheckmarkIcon), for: .normal)
    } else {
      cell.checkMarkButton.setImage(UIImage(named: themeController.uncheckedCheckmarkIcon), for: .normal)
    }
    cell.backgroundColor = themeController.backgroundColor
    return cell
  }
  
  @objc func checkmarkButtonPress(sender:UIButton) {
    let generator = UISelectionFeedbackGenerator()
    guard let cellID = sender.title(for: .normal) else {return}
    let image = controller.checkmarkButtonPressedController(cellID)
    let peek = SystemSoundID(1519)
    generator.prepare()
    AudioServicesPlaySystemSound(peek)
    generator.selectionChanged()
    sender.setImage(UIImage(named: image), for: .normal)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    contextItemTableView.deselectRow(at: indexPath, animated: true)
    let cell = contextItemTableView.cellForRow(at: indexPath) as! ContextItemTableViewCell
    guard let toDoItem = cell.toDoItem else {return}
    controller.setEditingToDo(toDoItem)
    performSegue(withIdentifier: segueIdentifiers.editFromContextSegue, sender: self)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let cell = contextItemTableView.cellForRow(at: indexPath) as! ContextItemTableViewCell
      guard let cloudID = cell.toDoItem?.cloudRecordID else {return}
      controller.deleteItem(ID: cloudID, index: indexPath)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return controller.returnContextHeaderHeight(section)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 48))
    let label = UILabel()
    let separator = UIView()
    separator.backgroundColor = .groupTableViewBackground
    returnedView.addSubview(separator)
    returnedView.addSubview(label)
    returnedView.backgroundColor = themeController.backgroundColor
    label.textColor = navigationController?.navigationBar.barTintColor
    label.text = controller.returnContextHeader(section)
    label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 18).isActive = true
    label.bottomAnchor.constraint(equalTo: returnedView.bottomAnchor, constant: -6).isActive = true
    label.heightAnchor.constraint(equalToConstant: 24).isActive = true
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 16).isActive = true
    separator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
    separator.widthAnchor.constraint(equalToConstant: (returnedView.frame.width - 32)).isActive = true
    return returnedView
  }
  
}
