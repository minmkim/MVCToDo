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
    let rowsPerSection = controller.rowsPerSection(for: section)
    return rowsPerSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
    guard let reminder = controller.returnReminder(for: indexPath) else {return cell}
    cell.reminder = reminder
    return cell
  }
  
//  @objc func checkmarkButtonPress(sender: UIButton) {
//    let generator = UISelectionFeedbackGenerator()
//    let peek = SystemSoundID(1519)
//    guard let cellID = sender.title(for: .normal) else {return}
//    let image = controller.checkmarkButtonPressedController(cellID)
//    generator.prepare()
//    AudioServicesPlaySystemSound(peek)
//    generator.selectionChanged()
//    sender.setImage(UIImage(named: image), for: .normal)
//  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 36))
    let label = UILabel()
    let separator = UIView()
    separator.backgroundColor = .groupTableViewBackground
    returnedView.addSubview(separator)
    returnedView.addSubview(label)
    returnedView.backgroundColor = .white
    label.textColor = .lightGray
    label.text = controller.headerTitleOfSections(for: section)
    label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 18).isActive = true
    label.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 17).isActive = true
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 16).isActive = true
    separator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
    separator.trailingAnchor.constraint(equalTo: returnedView.trailingAnchor, constant: -16).isActive = true

    
    if controller.checkIfToday(for: (label.text ?? "")) {
      let todayLabel = UILabel()
      returnedView.addSubview(todayLabel)
      todayLabel.textColor = .red
      todayLabel.text = "Today"
      todayLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
      todayLabel.translatesAutoresizingMaskIntoConstraints = false
      todayLabel.trailingAnchor.constraint(equalTo: returnedView.trailingAnchor, constant: -16).isActive = true
      todayLabel.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true
      todayLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
    return returnedView
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let cell = eventTableView.cellForRow(at: indexPath) as! EventTableViewCell
      eventTableView.beginUpdates()
      controller.deleteItem(reminder: cell.reminder, indexPath: indexPath)
      eventTableView.endUpdates()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    eventTableView.deselectRow(at: indexPath, animated: true)
  }
  
}
