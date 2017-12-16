//
//  File.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox.AudioServices

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = todayTableView.dequeueReusableCell(withIdentifier: "ContextItem", for: indexPath) as! EventTableViewCell
    let toDoItem = todayController.returnToDoInCell(index: indexPath)
    cell.toDoItem = toDoItem
    if indexPath.section == 0 {
      if cell.toDoItem?.dueDate != nil {
        cell.dueLabel.text = todayController.returnDueDate((cell.toDoItem?.dueDate!)!)
      }
      
    }
    cell.toDoLabel.textColor = themeController.mainTextColor
    cell.contextColor.backgroundColor = todayController.returnContextColor(cell.toDoItem?.context ?? "")
    cell.contextColor.layer.cornerRadius = 3.0
    if cell.toDoItem?.isChecked ?? false {
      cell.checkmarkButton.setImage(UIImage(named: themeController.checkedCheckmarkIcon), for: .normal)
    } else {
      cell.checkmarkButton.setImage(UIImage(named: themeController.uncheckedCheckmarkIcon), for: .normal)
    }
    cell.checkmarkButton.setTitle(cell.toDoItem?.calendarRecordID, for: .normal)
    cell.checkmarkButton.addTarget(self,action:#selector(checkmarkButtonPress), for:.touchUpInside)
    cell.backgroundColor = themeController.backgroundColor
    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return todayController.returnNumberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todayController.returnNumberOfRowInSection(section)
  }
  
  @objc func checkmarkButtonPress(sender: UIButton) {
    let generator = UISelectionFeedbackGenerator()
    let peek = SystemSoundID(1519)
    guard let cellID = sender.title(for: .normal) else {return}
    let image = todayController.checkmarkButtonPressedController(cellID)
    generator.prepare()
    AudioServicesPlaySystemSound(peek)
    generator.selectionChanged()
    sender.setImage(UIImage(named: image), for: .normal)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    todayTableView.deselectRow(at: indexPath, animated: true)
    let cell = todayTableView.cellForRow(at: indexPath) as! EventTableViewCell
    guard let toDoItem = cell.toDoItem else {return}
    todayController.setEditingToDo(toDoItem)
    performSegue(withIdentifier: segueIdentifiers.editFromTodaySegue, sender: self)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let cell = todayTableView.cellForRow(at: indexPath) as! EventTableViewCell
      guard let cloudID = cell.toDoItem?.calendarRecordID else {return}
      todayController.deleteItem(ID: cloudID, index: indexPath)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (shownIndexes.contains(indexPath) == false) {
      shownIndexes.append(indexPath)
      cell.alpha = 0.0
      let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 80, 0)
      cell.layer.transform = transform
      
      UIView.animate(withDuration: 0.1, delay: 0.05*Double(shownIndexes.count), options: [.curveEaseInOut], animations:  {
        cell.alpha = 1.0
        cell.layer.transform = CATransform3DIdentity
      }, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 48.0
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
    label.text = todayController.returnContextHeader(section)
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
