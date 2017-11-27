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
    cell.checkMarkButton.setTitle(cell.toDoItem?.cloudRecordID, for: .normal)
    cell.checkMarkButton.addTarget(self,action:#selector(checkmarkButtonPress), for:.touchUpInside)
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
  
  
}
