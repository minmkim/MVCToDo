//
//  CalendarDropViewController.swift
//  DueLife
//
//  Created by Min Kim on 10/31/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import MobileCoreServices
import UserNotifications

extension CalendarViewController: UICollectionViewDropDelegate {
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let indexPathCalendar = coordinator.destinationIndexPath,
      let _ = coordinator.items.first?.dragItem
      else {
        self.calendarCollectionView.reloadData()
        return
    }
    let droppedDateString = controller.convertIndexPathRowToDateString(indexPathCalendar.row)
    delegate?.reminderDroppedOnCalendarDate(droppedDateString)
    calendarCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    if let testPath = previousDragIndexPath {
      if let indexPath = destinationIndexPath {
        previousDragIndexPath = indexPath
        let previousCell = calendarCollectionView.cellForItem(at: testPath) as! CalendarCollectionViewCell
        previousCell.backgroundColor = themeController.backgroundColor
        if indexPath.row == 0 {
          previousCell.dayIndicatorView.backgroundColor = .red
        } else {
          previousCell.dayIndicatorView.backgroundColor = themeController.backgroundColor
        }
        let cell = calendarCollectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = .red
        cell.dayIndicatorView.backgroundColor  = .red
      }
    } else {
      if let indexPath = destinationIndexPath {
        previousDragIndexPath = indexPath
        let cell = calendarCollectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = .red
        cell.dayIndicatorView.backgroundColor  = .red
      }
    }
      return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
  }
}
