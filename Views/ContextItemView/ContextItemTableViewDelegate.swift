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
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return controller.returnNumberOfRowsInSection()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = contextItemTableView.dequeueReusableCell(withIdentifier: "ContextItem", for: indexPath) as! ContextItemTableViewCell
    let toDoItem = controller.returnToDoItemForCell(indexPath.row)
    cell.toDoItem = toDoItem
    cell.toDoItemLabel.textColor = themeController.mainTextColor
    cell.checkMarkButton.setTitle(cell.toDoItem?.cloudRecordID, for: .normal)
    cell.checkMarkButton.addTarget(self,action:#selector(checkmarkButtonPress), for:.touchUpInside)
    if cell.toDoItem?.checked ?? false {
      cell.checkMarkButton.setImage(UIImage(named: checkMarkAsset.checkedCircle), for: .normal)
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
      controller.deleteItem(ID: cloudID)
      
      contextItemTableView.beginUpdates()
      contextItemTableView.deleteRows(at: [indexPath], with: .fade)
      contextItemTableView.endUpdates()
    }
  }
  
}
