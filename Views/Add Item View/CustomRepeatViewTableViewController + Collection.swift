//
//  CustomRepeatViewTableViewController + Collection.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/22/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension CustomRepeatViewTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = ((calendarCollectionView.frame.width - 100) / 7)
    let height = (calendarCollectionView.frame.height / 5)
    return CGSize(width: width, height: height)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 4 {
      return 3
    } else {
      return 7
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "RepeatCalendarCell", for: indexPath) as! RepeatingCalendarCollectionViewCell
    let number = (indexPath.section * 7) + indexPath.row + 1
    cell.dayNumberLabel.text = String(describing: number)
    cell.indicatorView.layer.cornerRadius = 15
    
    if pressedDays.count != 0 {
      for day in pressedDays {
        var section = 0
        switch (day - 1) {
        case 0...6:
          section = 0
        case 7...13:
          section = 1
        case 14...20:
          section = 2
        case 21...27:
          section = 3
        default:
          section = 4
        }
        var row = 0
        switch (day - 1) {
        case 0...6:
          row = (day - 1)
        case 7...13:
          row = (day - 8)
        case 14...20:
          row = (day - 15)
        case 21...27:
          row = (day - 22)
        default:
          row = (day - 29)
        }
        if indexPath.row == row && indexPath.section == section {
          cell.indicatorView.backgroundColor = .red
        }
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = calendarCollectionView.cellForItem(at: indexPath) as! RepeatingCalendarCollectionViewCell
    if cell.indicatorView.backgroundColor == .white {
      cell.indicatorView.backgroundColor = .red
      cell.dayNumberLabel.textColor = .white
      pressedDays.append(Int(cell.dayNumberLabel.text!)!)
    } else {
      cell.indicatorView.backgroundColor = .white
      cell.dayNumberLabel.textColor = .black
      guard let index = pressedDays.index(where: {$0 == (Int(cell.dayNumberLabel.text!)!) }) else {return}
      pressedDays.remove(at: index)
    }
  }
  
  
  
}
