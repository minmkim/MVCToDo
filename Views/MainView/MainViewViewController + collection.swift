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
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 2
    case 1:
      let numberOfItems = controller.numberOfContext()
      return numberOfItems
    case 2:
      return 1
    default:
      return 0
      }
    }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = contextCollectionView.dequeueReusableCell(withReuseIdentifier: "ContextCards", for: indexPath) as! ContextItemCollectionViewCell
    cell.backView.layer.cornerRadius = 22
    cell.backView.layer.shadowColor = UIColor.black.cgColor
    cell.backView.layer.shadowOffset = CGSize(width: 0, height: 3)
    cell.backView.layer.shadowOpacity = 0.6
    cell.contextItemLabel.textColor = .white
    cell.numberOfContextLabel.textColor = .white
    cell.backView.clipsToBounds = false
    cell.layer.masksToBounds = false
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.editColor))
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        cell.contextItemLabel.text = "All"
        cell.numberOfContextLabel.text = ""
        cell.backView.backgroundColor =  themeController.mainThemeColor
        return cell
      } else {
        cell.contextItemLabel.text = "Today"
        cell.numberOfContextLabel.text = controller.returnCellNumberOfToday()
        cell.backView.backgroundColor =  controller.returnColor("Today")
        return cell
      }
      
    case 1:
      cell.contextItemLabel.text = controller.returnContextString(indexPath.row)
      cell.numberOfContextLabel.text = controller.returnCellNumberOfContextString(indexPath.row)
      cell.backView.backgroundColor = controller.returnColor(cell.contextItemLabel.text!)
      cell.addGestureRecognizer(gesture)
      return cell
    default:
      cell.contextItemLabel.text = "Add Context"
      cell.numberOfContextLabel.text = ""
      cell.backView.backgroundColor =  controller.contextColors[indexPath.row]
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        let size = self.view.convert(cell.backView.frame, from: cell.backView.superview)
        guard let color = cell.backView.backgroundColor else {return}
        let fakeHeader = returnTemporaryHeaderView(frameSize: size, color: color)
        let fakeLabel = returnTemporaryContextLabel(frameSize: size, contextString: cell.contextItemLabel.text ?? "")
        let fakeBody = returnTemporaryBody()
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
          if self.themeController.isDarkTheme {
            fakeHeader.backgroundColor = .black
          } else {
            fakeHeader.backgroundColor = self.themeController.mainThemeColor
          }
          
          fakeLabel.frame = CGRect(x: 15.667, y: labelHeight, width: Double(self.view.frame.width - 31.334), height: 40.0)
          fakeHeader.frame = CGRect(x: 0.0, y: 0.0, width: Double(width), height: headerHeight)
          fakeHeader.layer.cornerRadius = 0
          fakeBody.frame = CGRect(x: 0.0, y: headerHeight, width: Double(width), height: Double(self.view.frame.height))
          
        }) { (_) in
          DispatchQueue.main.async {
            self.navigationController?.pushViewController(self.allViewController!, animated: false)
          }
          cell.backView.backgroundColor = originalColor
          cell.backView.layer.shadowColor = originalShadow
          cell.contextItemLabel.textColor = originalLabelColor
          DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            fakeHeader.removeFromSuperview()
            fakeBody.removeFromSuperview()
            fakeLabel.removeFromSuperview()
          }

        }
        
      } else {
        let size = self.view.convert(cell.backView.frame, from: cell.backView.superview)
        guard let color = cell.backView.backgroundColor else {return}
        let fakeHeader = returnTemporaryHeaderView(frameSize: size, color: color)
        let fakeLabel = returnTemporaryContextLabel(frameSize: size, contextString: cell.contextItemLabel.text ?? "")
        let fakeBody = returnTemporaryBody()
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
        
        UIView.animate(withDuration: 0.3, animations: {
          UIApplication.shared.statusBarStyle = .lightContent
          fakeLabel.frame = CGRect(x: 15.667, y: labelHeight, width: Double(self.view.frame.width - 31.334), height: 40.0)
          fakeHeader.frame = CGRect(x: 0.0, y: 0.0, width: Double(width), height: headerHeight)
          fakeHeader.layer.cornerRadius = 0
          fakeBody.frame = CGRect(x: 0.0, y: headerHeight, width: Double(width), height: Double(self.view.frame.height))
          
        }) { (_) in
          cell.backView.backgroundColor = originalColor
          cell.backView.layer.shadowColor = originalShadow
          cell.contextItemLabel.textColor = originalLabelColor
          self.performSegue(withIdentifier: segueIdentifiers.todayViewSegue, sender: self)
          fakeHeader.removeFromSuperview()
          fakeBody.removeFromSuperview()
          fakeLabel.removeFromSuperview()
        }
      }
      
    case 1:
      controller.setIndexPathForContextSelect(indexPath.row)
      let size = self.view.convert(cell.backView.frame, from: cell.backView.superview)
      guard let color = cell.backView.backgroundColor else {return}
      let fakeHeader = returnTemporaryHeaderView(frameSize: size, color: color)
      let fakeLabel = returnTemporaryContextLabel(frameSize: size, contextString: cell.contextItemLabel.text ?? "")
      let fakeBody = returnTemporaryBody()
      self.view.addSubview(fakeHeader)
      self.view.bringSubview(toFront: fakeHeader)
      self.view.addSubview(fakeLabel)
      self.view.addSubview(fakeBody)
      self.view.bringSubview(toFront: fakeBody)
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
      
      UIView.animate(withDuration: 0.3, animations: {
        UIApplication.shared.statusBarStyle = .lightContent
        fakeLabel.frame = CGRect(x: 15.667, y: labelHeight, width: Double(self.view.frame.width - 34), height: 40.0)
        fakeHeader.frame = CGRect(x: 0.0, y: 0.0, width: Double( self.view.frame.width), height: headerHeight)
        fakeHeader.layer.cornerRadius = 0
        fakeBody.frame = CGRect(x: 0.0, y: headerHeight, width: Double( self.view.frame.width), height: Double(self.view.frame.height))
        
      }) { (_) in
        cell.backView.backgroundColor = originalColor
        cell.backView.layer.shadowColor = originalShadow
        cell.contextItemLabel.textColor = originalLabelColor
        self.performSegue(withIdentifier: segueIdentifiers.contextItemSegue, sender: self)
        fakeHeader.removeFromSuperview()
        fakeBody.removeFromSuperview()
        fakeLabel.removeFromSuperview()
      }
    case 2:
      contextField.isEnabled = true
      contextField.becomeFirstResponder()
      contextField.text = ""
      UIView.animate(withDuration: 0.3) {
        self.addContextView.frame = CGRect(x: 8, y: ((self.view.frame.height / 2) - 250), width: (self.view.frame.width - 16), height: 200)
      }
    default:
      return
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (contextCollectionView.frame.width - 25), height: 75.0)
  }
  
  @objc func editColor(sender: UILongPressGestureRecognizer) {
    guard let cell = sender.view as? ContextItemCollectionViewCell else {return}
    let indexPath = contextCollectionView.indexPath(for: cell)
    if indexPath?.section == 0 && indexPath?.row == 0 {
      return
    } else if indexPath?.section == 2 {
      return
    }
    controller.editingContext = indexPath
    contextField.text = cell.contextItemLabel.text
    contextField.isEnabled = false
    addContextView.backgroundColor = cell.backView.backgroundColor
    UIView.animate(withDuration: 0.3) {
      self.addContextView.frame = CGRect(x: 8, y: ((self.view.frame.height / 2) - 250), width: (self.view.frame.width - 16), height: 200)
    }
  }
  
  func returnTemporaryHeaderView(frameSize: CGRect, color: UIColor) -> UIView {
    let fakeHeader = UIView()
    fakeHeader.frame = frameSize
    fakeHeader.layer.cornerRadius = 22
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
  
  func returnTemporaryBody() -> UIView {
    let fakeBody = UIView()
    fakeBody.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
    fakeBody.backgroundColor = themeController.backgroundColor
    return fakeBody
  }
  
}

