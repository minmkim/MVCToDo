//
//  CalendarDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/15/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 400
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let todayIndexPath = IndexPath(row: 100, section: 0)
    let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCollectionViewCell
    cell.backgroundColor = themeController.backgroundColor
    let newVariable = VariableChange()
    newVariable.variable = collectionView.indexPathsForVisibleItems
    let monthString = controller.updateMonthLabel(IndexArray: newVariable.variable)
    displayMonthText = monthString
    cell.numberOfMonthLabel.text = controller.calculateDayNumberForCell(indexPathRow: indexPath.row)
    cell.dayOfWeekLabel.text = controller.calculateDayOfWeekLabelForCell(indexPathRow: indexPath.row)
    cell.dayIndicatorView.layer.cornerRadius = 13
    if themeController.needShadow {
      cell.dayIndicatorView.layer.shadowOffset = CGSize(width: 0, height: 3)
      cell.dayIndicatorView.layer.shadowOpacity = 0.7
    } else {
      cell.dayIndicatorView.layer.shadowOpacity = 0
    }
    
    switch indexPath.row {
    case selectedCalendarIndexPath?.row ?? 1000000: // if nil, 100000 will not load
      cell.dayIndicatorView.backgroundColor = themeController.mainThemeColor
      cell.dayIndicatorView.layer.shadowColor = UIColor.black.cgColor
      cell.numberOfMonthLabel.textColor = .white
    case todayIndexPath.row:
      cell.dayIndicatorView.backgroundColor = .red
      cell.dayIndicatorView.layer.shadowColor = UIColor.black.cgColor
      cell.numberOfMonthLabel.textColor = .white
    default:
      cell.dayIndicatorView.backgroundColor = themeController.backgroundColor
      if themeController.needShadow {
        cell.dayIndicatorView.layer.shadowColor = UIColor.white.cgColor
      } else {
        cell.dayIndicatorView.layer.shadowColor = UIColor.black.cgColor
      }
      cell.numberOfMonthLabel.textColor = themeController.mainTextColor
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let pressedDate = controller.convertIndexPathRowToDateString(indexPath.row)
    delegate?.calendarDayPressed(pressedDate)
    selectedCalendarIndexPath = indexPath
    guard let cell = calendarCollectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {return}
    cell.dayIndicatorView.backgroundColor = themeController.mainThemeColor
    cell.dayIndicatorView.layer.shadowColor = UIColor.black.cgColor
    cell.numberOfMonthLabel.textColor = .white
    UIView.animate(withDuration: 0.1, animations: {
      let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      cell.dayIndicatorView.transform = scaleTransform
    }) { (_) in
      UIView.animate(withDuration: 0.1, animations: {
        cell.dayIndicatorView.transform = CGAffineTransform.identity
      }) { (_) in
        self.calendarCollectionView.reloadData()
      }
    }
  }
  
  
  
}
