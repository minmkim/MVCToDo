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
    let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCollectionViewCell
    cell.numberOfMonthLabel.text = controller.calculateDayNumberForCell(indexPathRow: indexPath.row)
    cell.dayOfWeekLabel.text = controller.calculateDayOfWeekLabelForCell(indexPathRow: indexPath.row)
    cell.dayIndicatorView.layer.cornerRadius = 13
    cell.dayIndicatorView.layer.shadowOffset = CGSize(width: 0, height: 3)
    cell.dayIndicatorView.layer.shadowOpacity = 0.7
    
    if indexPath == selectedCalendarIndexPath {
      cell.dayIndicatorView.backgroundColor = .red
      cell.dayIndicatorView.layer.shadowColor = UIColor.black.cgColor
      cell.numberOfMonthLabel.textColor = .white
    } else {
      cell.dayIndicatorView.backgroundColor = .white
      cell.dayIndicatorView.layer.shadowColor = UIColor.white.cgColor
      cell.numberOfMonthLabel.textColor = .black
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedCalendarIndexPath = indexPath
    guard let cell = calendarCollectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {return}
    cell.dayIndicatorView.backgroundColor = .red
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
