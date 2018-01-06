//
//  MainViewViewController + collection.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/28/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension MainViewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let numberOfItems = controller.numberOfRows()
    return numberOfItems
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = themedCell(for: indexPath)
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.editColor))
    cell.saveButton.addTarget(self,action:#selector(saveButtonPress), for:.touchUpInside)
    cell.cancelButton.addTarget(self,action:#selector(cancelButtonPress), for:.touchUpInside)
    cell.deleteButton.addTarget(self,action:#selector(deleteButtonPress), for:.touchUpInside)
    switch indexPath.row {
    case 0:
      cell.contextItemLabel.text = "All"
      cell.numberOfContextLabel.text = ""
      cell.backView.backgroundColor =  themeController.mainThemeColor
      return cell
    case 1:
      cell.contextItemLabel.text = "Today"
//      cell.numberOfContextLabel.text = controller.returnCellNumberOfToday()
      cell.backView.backgroundColor =  colors.darkRed
      return cell
    case (controller.listOfContext.count + 2):
      cell.contextItemLabel.text = ""
      cell.contextItemLabel.attributedPlaceholder = NSAttributedString(string: "Add Context", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
      cell.numberOfContextLabel.text = ""
      cell.isEditing = true
      cell.backView.backgroundColor = .red
      return cell
    default:
      cell.contextItemLabel.text = controller.returnContextString(indexPath.row - 2)
      cell.numberOfContextLabel.text = controller.returnCellNumberOfContextString(indexPath.row - 2)
      cell.backView.backgroundColor = controller.returnColor(cell.contextItemLabel.text!)
      cell.addGestureRecognizer(gesture)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    if indexPath.row != (controller.listOfContext.count + 2) {
      let size = self.view.convert(cell.backView.frame, from: cell.backView.superview)
      transitionViews(for: size, cell: cell, completion: {
        DispatchQueue.main.async {
        switch indexPath.row {
        case 0:
          self.performSegue(withIdentifier: segueIdentifiers.allSegue, sender: nil)
        case 1:
          self.performSegue(withIdentifier: segueIdentifiers.todayViewSegue, sender: self)
        default:
          self.controller.setIndexPathForContextSelect(indexPath.row - 2)
          self.performSegue(withIdentifier: segueIdentifiers.contextItemSegue, sender: self)
          }
        }
      })
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return -215
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if let index = controller.previousEditedIndexPath {
      if index == indexPath && index.row != (controller.listOfContext.count + 2) && indexPath.row != (controller.listOfContext.count + 1) {
        return CGSize(width: (contextCollectionView.frame.width - 25), height: 475)
      }
    }
    return CGSize(width: (contextCollectionView.frame.width - 25), height: 275)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(10, 0, 0, 0)
  }
  
  func themedCell(for indexPath: IndexPath) -> ContextItemCollectionViewCell {
    let cell = contextCollectionView.dequeueReusableCell(withReuseIdentifier: "ContextCards", for: indexPath) as! ContextItemCollectionViewCell
    cell.contextItemLabel.isEnabled = false
    if themeController.isDarkTheme {
      cell.contextItemLabel.keyboardAppearance = .dark
    } else {
      cell.contextItemLabel.keyboardAppearance = .default
    }
    cell.backView.layer.shadowColor = UIColor.black.cgColor
    cell.backView.layer.shadowOffset = CGSize(width: 0, height: -3)
    cell.backView.layer.shadowOpacity = 0.3
    cell.backView.layer.cornerRadius = 10
    cell.isEditing = false
    cell.contextItemLabel.textColor = .white
    cell.numberOfContextLabel.textColor = .white
    cell.backView.clipsToBounds = false
    cell.layer.masksToBounds = false
    return cell
  }
  
  @objc func saveButtonPress(sender: UIButton) {
    controller.saveButtonPressed()
  }
  
  @objc func cancelButtonPress(sender: UIButton) {
    controller.setControllerModeToNormal()
  }
  
  @objc func deleteButtonPress(sender: UIButton) {
    let alertController = UIAlertController(title: "Deleting Context", message: "Deleting this context will also delete all the reminders associated with the context. Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "Yes", style: .default) { (result : UIAlertAction) -> Void in
      self.controller.deleteButtonPressed()
    }
    let cancelAction = UIAlertAction(title: "No", style: .default) { (result : UIAlertAction) -> Void in
      alertController.dismiss(animated: true, completion: nil)
    }
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  @objc func editColor(sender: UILongPressGestureRecognizer) {
    guard let cell = sender.view as? ContextItemCollectionViewCell else {return}
    guard let indexPath = contextCollectionView.indexPath(for: cell) else {return}
    controller.editingContext(for: indexPath)
  }
  
  func transitionViews(for size: CGRect, cell: ContextItemCollectionViewCell, completion: @escaping () -> Void) {
    guard let color = cell.backView.backgroundColor else {return}
    let fakeHeader = returnTemporaryHeaderView(frameSize: size, color: color)
    let fakeLabel = returnTemporaryContextLabel(frameSize: size, contextString: cell.contextItemLabel.text ?? "")
    let fakeBody = returnTemporaryBody(frameSize: size)
    self.view.addSubview(fakeHeader)
    self.view.bringSubview(toFront: fakeHeader)
    self.view.addSubview(fakeLabel)
    self.view.addSubview(fakeBody)
    self.view.bringSubview(toFront: fakeBody)
    
    let width = self.view.frame.width
    var headerHeight: Double = 0.0
    var labelHeight: Double = 0.0
    
    if self.view.frame.height == 812 { //iPhone x
      headerHeight = 141.0
      labelHeight = 92.0
    } else {
      headerHeight = 116.0
      labelHeight = 68.0
    }
    let originalColor = cell.backView.backgroundColor
    let originalShadow = cell.backView.layer.shadowColor
    let originalLabelColor = cell.contextItemLabel.textColor
    cell.backView.backgroundColor = self.themeController.backgroundColor
    cell.backView.layer.shadowColor = self.themeController.backgroundColor.cgColor
    cell.contextItemLabel.textColor = self.themeController.backgroundColor
    
    UIView.animate(withDuration: 0.2, animations: {
      UIApplication.shared.statusBarStyle = .lightContent
      if cell.contextItemLabel.text == "All" {
        fakeLabel.text = "Due Life"
        if self.themeController.isDarkTheme {
          fakeHeader.backgroundColor = .black
        } else {
          fakeHeader.backgroundColor = self.themeController.mainThemeColor
        }
      }
      fakeLabel.frame = CGRect(x: 15.667, y: labelHeight, width: Double(self.view.frame.width - 31.334), height: 40.0)
      fakeHeader.frame = CGRect(x: 0.0, y: 0.0, width: Double(width), height: headerHeight)
      fakeHeader.layer.cornerRadius = 0
      fakeBody.frame = CGRect(x: 0.0, y: headerHeight, width: Double(width), height: Double(self.view.frame.height))
    }) { (_) in
      completion()
      cell.backView.backgroundColor = originalColor
      cell.backView.layer.shadowColor = originalShadow
      cell.contextItemLabel.textColor = originalLabelColor
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        fakeHeader.removeFromSuperview()
        fakeBody.removeFromSuperview()
        fakeLabel.removeFromSuperview()
      }
    }
  }
  
  func returnTemporaryHeaderView(frameSize: CGRect, color: UIColor) -> UIView {
    let fakeHeader = UIView()
    fakeHeader.frame = frameSize
    fakeHeader.layer.cornerRadius = 10
    fakeHeader.backgroundColor = color
    return fakeHeader
  }
  
  func returnTemporaryContextLabel(frameSize: CGRect, contextString: String) -> UILabel {
    let fakeLabel = UILabel()
    fakeLabel.text = contextString
    fakeLabel.frame = CGRect(x: Double(frameSize.minX + 20), y: Double(frameSize.minY + 8), width: Double(self.view.frame.width - 31.5), height: Double(40))
    fakeLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
    fakeLabel.textColor = .white
    return fakeLabel
  }
  
  func returnTemporaryBody(frameSize: CGRect) -> UIView {
    let fakeBody = UIView()
    fakeBody.frame = CGRect(x: 0, y: frameSize.maxY - 60, width: view.frame.width, height: view.frame.height)
    fakeBody.backgroundColor = themeController.backgroundColor
    return fakeBody
  }
  
}
