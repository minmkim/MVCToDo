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
  
  @IBOutlet weak var addItemButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    contextItemTableView.delegate = self
    contextItemTableView.dataSource = self
    let color = controller.returnNavigationBarColor()
    navigationController?.navigationBar.barTintColor = color
    contextItemTableView.backgroundColor = themeController.backgroundColor
    footerView.backgroundColor = themeController.backgroundColor
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.7
    addItemButton.layer.shadowColor = UIColor.black.cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
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
      destination.controller = AddEditToDoController(ItemToEdit: toDoItem)
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
    contextItemTableView.reloadData()
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
