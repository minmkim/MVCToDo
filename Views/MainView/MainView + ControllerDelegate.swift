//
//  MainView + ControllerDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 1/4/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension MainViewViewController: PassToDoModelToMainDelegate {
  func returnToDoModel(_ controller: RemindersController) {
    print("delegated")
    self.controller = MainViewController(controller: controller)
  }
}

extension MainViewViewController: UpdateCollectionViewDelegate {
  func insertContext(at index: IndexPath) {
    print("insert context delegate")
    contextCollectionView.insertItems(at: [index])
  }
  func deleteContext(at index: IndexPath) {
    print("deleting at \(index)")
    contextCollectionView.deleteItems(at: [index])
  }
  func updateContext() {
    print("updateContext delegate")
    DispatchQueue.main.async {
      self.contextCollectionView.reloadData()
    }
  }
  func insertSection(_ section: Int) {
    contextCollectionView.insertSections([section])
  }
  func deleteSections(_ section: Int) {
    contextCollectionView.deleteSections([section])
  }
  func moveItem(fromIndex: IndexPath, toIndex: IndexPath) {
    contextCollectionView.moveItem(at: fromIndex, to: toIndex)
  }
  
  func addContext() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    let indexPath = IndexPath(row: (controller.listOfContext.count + 2), section: 0)
    DispatchQueue.main.async {
      self.contextCollectionView.insertItems(at: [indexPath])
      let cell = self.contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
      //      cell.buttonView.isHidden = true
      self.contextCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 350, right: 0)
      self.contextCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
      cell.contextItemLabel.becomeFirstResponder()
    }
  }
  
  func editToNormal(for indexPath: IndexPath) {
    print("edit to normal")
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    cell.contextItemLabel.resignFirstResponder()
    cell.isEditing = false
    contextCollectionView.performBatchUpdates(nil, completion: nil)
    contextCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
  }
  
  func addToNormal() {
    let indexPath = IndexPath(row: (controller.listOfContext.count + 2), section: 0)
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    cell.contextItemLabel.resignFirstResponder()
    contextCollectionView.deleteItems(at: [indexPath])
    contextCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
  }
  
  func editContext(for indexPath: IndexPath) {
    print("edit context")
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    cell.isEditing = true
    self.contextCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 350, right: 0)
    contextCollectionView.performBatchUpdates(nil, completion: nil)
  }
  
  func returnContextDataToEditOrAdd(for indexPath: IndexPath) {
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    guard let context = cell.contextItemLabel.text else {return}
    guard let color = cell.backView.backgroundColor else {return}
    controller.createOrEditCalendar(context: context, color: color)
  }
  
  func returnContextDataToDelete(for indexPath: IndexPath) {
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    guard let context = cell.contextItemLabel.text else {return}
    controller.deleteCalendar(context: context)
  }
  
}

extension MainViewViewController: ReturnRemindersControllerDelegate {
  func returnRemindersController(_ remindersController: RemindersController) {
    print("delegated controller")
    controller.remindersController = remindersController
  }
}

extension MainViewViewController: ReturnRemindersControllerFromTodayDelegate {
  func delegateRemindersController(_ remindersController: RemindersController) {
    print("delegated controller")
    controller.remindersController = remindersController
  }
}
