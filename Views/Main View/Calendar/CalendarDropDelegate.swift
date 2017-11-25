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
    //    coordinator.session.loadObjects(ofClass: NSString.self) { items in
    //      // convert the item provider array to a string array or bail out
    //      guard let strings = items as? [String] else { return }
    //    }
    let droppedDateString = controller.convertIndexPathRowToDateString(indexPathCalendar.row)
    delegate?.toDoDroppedOnCalendarDate(droppedDateString)
    calendarCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    if let testPath = previousDragIndexPath {
      if let indexPath = destinationIndexPath {
        previousDragIndexPath = indexPath
        let previousCell = calendarCollectionView.cellForItem(at: testPath) as! CalendarCollectionViewCell
        previousCell.backgroundColor = .white
        let cell = calendarCollectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
      }
    } else {
      if let indexPath = destinationIndexPath {
        previousDragIndexPath = indexPath
        let cell = calendarCollectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
      }
    }
      return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
  }
}

