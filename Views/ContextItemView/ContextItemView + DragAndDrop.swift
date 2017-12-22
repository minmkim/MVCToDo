//

//  Created by Min Kim on 10/31/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import MobileCoreServices

extension ContextItemViewController: UITableViewDragDelegate {
  
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let cell = contextItemTableView.cellForRow(at: indexPath) as! ContextItemTableViewCell
    guard let reminder = cell.reminder else {return [UIDragItem]()}
    controller.dragAndDropInitiated(reminder)
    controller.returnDragIndexPath(indexPath)
    guard let data = (reminder.calendarRecordID).data(using: .utf8) else { return [] }
    let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
    _ = UIDragItem(itemProvider: itemProvider)
    return [UIDragItem(itemProvider: itemProvider)]
  }
}

extension ContextItemViewController: UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard let indexPathEvent = coordinator.destinationIndexPath else {return}
    controller.updateNewParentSectionWithDrop(indexPathEvent)
  }
  
  func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSString.self)
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    
    return UITableViewDropProposal(operation: .move, intent: .automatic)
  }
  
}
