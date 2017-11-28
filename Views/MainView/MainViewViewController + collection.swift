//
//  MainViewViewController + collection.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/28/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension MainViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
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
    
    switch indexPath.section {
    case 0:
      cell.contextItemLabel.text = "All"
      cell.numberOfContextLabel.text = ""
      cell.backView.backgroundColor =  controller.contextColors[indexPath.row]
      return cell
    case 1:
      cell.contextItemLabel.text = controller.returnContextString(indexPath.row)
      cell.numberOfContextLabel.text = controller.returnCellNumberOfContextString(indexPath.row)
      cell.backView.backgroundColor = controller.returnColor(cell.contextItemLabel.text!)
      let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.editColor))
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
    print(indexPath)
    print(cell)
    UIView.animate(withDuration: 0.3, animations: {
      let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      cell.backView?.transform = scaleTransform
    }) { (_) in
      UIView.animate(withDuration: 0.3, animations: {
        cell.backView?.transform = CGAffineTransform.identity
      })
    }
    switch indexPath.section {
    case 0:
      performSegue(withIdentifier: segueIdentifiers.allSegue, sender: self)
    case 1:
      controller.setIndexPathForContextSelect(indexPath.row)
      performSegue(withIdentifier: segueIdentifiers.contextItemSegue, sender: self)
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
  
  @objc func editColor(sender: UILongPressGestureRecognizer) {
    guard let cell = sender.view as? ContextItemCollectionViewCell else {return}
    let indexPath = contextCollectionView.indexPath(for: cell)
    controller.editingContext = indexPath
    contextField.text = cell.contextItemLabel.text
    contextField.isEnabled = false
    addContextView.backgroundColor = controller.returnColor(cell.contextItemLabel.text ?? "")
    UIView.animate(withDuration: 0.3) {
      self.addContextView.frame = CGRect(x: 8, y: ((self.view.frame.height / 2) - 250), width: (self.view.frame.width - 16), height: 200)
    }
  }
  
}

