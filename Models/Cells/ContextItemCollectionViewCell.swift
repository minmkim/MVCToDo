//
//  ContextItemCollectionViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/28/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ContextItemCollectionViewCell: UICollectionViewCell {
  
  let contextColors = [colors.red, colors.darkRed, colors.purple, colors.lightPurple, colors.darkBlue, colors.lightBlue, colors.teal, colors.turqoise, colors.hazel, colors.green, colors.lightGreen, colors.greenYellow, colors.lightOrange, colors.orange, colors.darkOrange, colors.thaddeus, colors.brown, colors.gray]
  
  
  @IBOutlet weak var contextItemLabel: UITextField!
  @IBOutlet weak var numberOfContextLabel: UILabel!
  @IBOutlet weak var backView: UIView!
  
  @IBOutlet weak var saveCancelStack: UIStackView!
  @IBOutlet weak var buttonView: UIView!
  @IBOutlet var colorButtons: [UIButton]!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  var isEditing: Bool? {
    didSet {
      if isEditing == true {
        contextItemLabel.isEnabled = true
        buttonView.isHidden = false
        saveCancelStack.isHidden = false
        buttonView.layer.cornerRadius = 10
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 3)
        buttonView.layer.shadowOpacity = 0.6
        var counter = 0
        for button in colorButtons {
          button.layer.cornerRadius = 12.5
          button.layer.shadowColor = UIColor.black.cgColor
          button.layer.shadowOffset = CGSize(width: 0, height: 3)
          button.layer.shadowOpacity = 0.6
          button.backgroundColor = contextColors[counter]
          counter += 1
        }
      } else {
        contextItemLabel.isEnabled = false
        buttonView.isHidden = true
        saveCancelStack.isHidden = true
        buttonView.layer.shadowOpacity = 0.0
        for button in colorButtons {
          button.layer.shadowOpacity = 0.0
        }
      }
    }
  }
  
  @IBAction func colorButtonPress(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3, animations: {
      self.backView.backgroundColor = sender.backgroundColor
      let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      sender.transform = scaleTransform
    }) { (_) in
      UIView.animate(withDuration: 0.3, animations: {
        sender.transform = CGAffineTransform.identity
      })
    }
  }
  
}
