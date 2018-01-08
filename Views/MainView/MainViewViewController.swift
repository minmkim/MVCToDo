//
//  MainViewViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class MainViewViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var contextCollectionView: UICollectionView!
  var controller: MainViewController!
  var themeController = ThemeController()
  var previousEditedIndexPath: IndexPath?
  
  @IBOutlet weak var addItemButton: UIButton!
  @IBAction func addButtonPressed(_ sender: Any) {
    if UserDefaults.standard.bool(forKey: "ReminderPermission") {
      controller.addContextButtonPressed()
    } else {
      UserDefaults.standard.set(false, forKey: "ReminderPermission")
      let alertController = UIAlertController(title: "Sorry!", message: "Due Life uses the iCloud Reminders backend to store your reminders. Please go to Settings and give Due Life permission to your reminders to use this app!", preferredStyle: UIAlertControllerStyle.alert)
      let okayAction = UIAlertAction(title: "Okay", style: .default) { (result : UIAlertAction) -> Void in
        alertController.dismiss(animated: true, completion: nil)
      }
      alertController.addAction(okayAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = themeController.backgroundColor
    contextCollectionView.backgroundColor = themeController.backgroundColor
    addItemButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    addItemButton.layer.shadowOpacity = 0.6
    addItemButton.layer.shadowColor = UIColor.black.cgColor
    addItemButton.setImage(UIImage(named: themeController.addCircle), for: .normal)
    setNavigationItemProperties()
    if #available(iOS 11.0, *) {
      contextCollectionView?.contentInsetAdjustmentBehavior = .always
    }
    contextCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    contextCollectionView.delegate = self
    contextCollectionView.dataSource = self
    if themeController.isDarkTheme {
      UIApplication.shared.statusBarStyle = .lightContent
    } else {
      UIApplication.shared.statusBarStyle = .default
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    controller.updateCollectionViewDelegate = self
  }
  
  func setNavigationItemProperties() {
    navigationItem.title = "Contexts"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .white
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    if UserDefaults.standard.bool(forKey: "ReminderPermission") {
      DispatchQueue.main.async() { // update contexts
        self.contextCollectionView.reloadData()
      }
    }
    
    themeController.checkTheme()
    if contextCollectionView.backgroundColor != themeController.backgroundColor {
      addItemButton.setImage(UIImage(named: themeController.addCircle), for: .normal)
      contextCollectionView.backgroundColor = themeController.backgroundColor
      self.view.backgroundColor = themeController.backgroundColor
      if themeController.isDarkTheme {
        UIApplication.shared.statusBarStyle = .lightContent
      } else {
        UIApplication.shared.statusBarStyle = .default
      }
    }
    
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    contextCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ContextItemSegue" {
      let destination = segue.destination as! ContextItemViewController
      let title = controller.returnContextString(controller.selectedContextIndex)
      destination.controller = ContextItemController(remindersController: controller.remindersController, title: title)
      destination.returnRemindersControllerDelegate = self
      destination.navigationItem.title = title
    } else if segue.identifier == segueIdentifiers.todayViewSegue {
       let destination = segue.destination as! TodayViewController
      let todayController = TodayController(controller: controller.remindersController)
      destination.todayController = todayController
      destination.returnRemindersControllerDelegate = self
      navigationController?.navigationBar.barTintColor = colors.darkRed
    } else if segue.identifier == segueIdentifiers.allSegue {
      let destination = segue.destination as! ViewController
      destination.passToDoModelDelegate = self
      destination.remindersController = controller.remindersController
      DispatchQueue.main.async {
        UIApplication.shared.statusBarStyle = .lightContent
      }
    }
  }
  
  @IBAction func unwindToMainViewFromAll(sender: UIStoryboardSegue) {
    print("unwind")
  }
}