//
//  ContextItemViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ContextItemViewController: UIViewController {

  @IBOutlet weak var contextItemTableView: UITableView!
  @IBOutlet weak var footerView: UIView!
  var controller = ContextItemController()
  var themeController = ThemeController()
  var shownIndexes : [IndexPath] = []
  
  @IBOutlet weak var addItemButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    contextItemTableView.delegate = self
    contextItemTableView.dataSource = self
    contextItemTableView.dragDelegate = self
    contextItemTableView.dragInteractionEnabled = true
    contextItemTableView.dropDelegate = self
    controller.delegate = self
    let color = controller.returnNavigationBarColor()
    navigationController?.navigationBar.barTintColor = color
    contextItemTableView.backgroundColor = themeController.backgroundColor
    view.backgroundColor = themeController.backgroundColor
    footerView.backgroundColor = themeController.backgroundColor
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
    addItemButton.setImage(UIImage(named: themeController.addCircle), for: .normal)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
  
  @IBAction func buttonPress(_ sender: Any) {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    UIView.animate(withDuration: 0.2, animations: {
      let rotateTransform = CGAffineTransform(rotationAngle: .pi)
      self.addItemButton.transform = rotateTransform
    }) { (_) in
      
      self.addItemButton.transform = CGAffineTransform.identity
    }
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: segueIdentifiers.addFromContextSegue, sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.editFromContextSegue {
      let destination = segue.destination as! AddItemTableViewController
      guard let toDoItem = controller.returnEditingToDo() else {return}
  //    destination.controller = AddEditToDoController(ItemToEdit: toDoItem)
      destination.controller.segueIdentity = segueIdentifiers.editFromContextSegue
    } else if segue.identifier == segueIdentifiers.addFromContextSegue {
      let navigation: UINavigationController = segue.destination as! UINavigationController
      var vc = AddItemTableViewController.init()
      vc = navigation.viewControllers[0] as! AddItemTableViewController
      vc.controller = AddEditToDoController()
      vc.controller.contextString = self.navigationItem.title
      vc.controller.segueIdentity = segueIdentifiers.addFromContextSegue
      vc.navigationController?.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
      vc.navigationController?.navigationBar.tintColor = .white
    }
  }

  @IBAction func unwindToContextToDo(sender: UIStoryboardSegue) {
    controller.toDoItemsInContext()
    controller.returnContextHeaders()
    contextItemTableView.reloadData()
  }

}

extension ContextItemViewController: UpdateContextItemTableViewDelegate {
  func deleteRow(_ indexPath: IndexPath) {
    print("delete row")
    contextItemTableView.deleteRows(at: [indexPath], with: .fade)
  }
  func deleteSection(_ indexPath: IndexPath) {
    print("delete section")
    contextItemTableView.deleteSections([indexPath.section], with: .fade)
  }
  func beginUpdate() {
    print("update")
    contextItemTableView.beginUpdates()
  }
  func endUpdate() {
    print("end update")
    contextItemTableView.endUpdates()
  }
  func insertSection(_ indexPath: IndexPath) {
    contextItemTableView.insertSections([indexPath.section], with: .fade)
  }
  func insertRow(_ indexPath: IndexPath) {
    contextItemTableView.insertRows(at: [indexPath], with: .fade)
  }
  func moveRowAt(originIndex: IndexPath, destinationIndex: IndexPath) {
    print("moved")
    contextItemTableView.moveRow(at: originIndex, to: destinationIndex)
  }
  func updateCell(originIndex: IndexPath, updatedToDo: ToDo) {
    let cell = contextItemTableView.cellForRow(at: originIndex) as! ContextItemTableViewCell
    cell.toDoItem = updatedToDo
  }
}
