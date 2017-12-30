//
//  MainViewViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class MainViewViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var addContextField: UITextField!
  @IBOutlet weak var addView: UIView!
  @IBOutlet weak var contextCollectionView: UICollectionView!
  var controller: MainViewController!
  var themeController = ThemeController()
  
  @IBOutlet var addContextColorButtons: [UIButton]!
  @IBOutlet weak var contextColorButtonBackView: UIView!
  
  @IBAction func addContextColorButtonPress(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3, animations: {
      self.addView.backgroundColor = sender.backgroundColor
      let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      sender.transform = scaleTransform
    }) { (_) in
      UIView.animate(withDuration: 0.3, animations: {
        sender.transform = CGAffineTransform.identity
      })
    }
  }
  
  @IBOutlet weak var addContextSaveButton: UIButton!
  @IBAction func addContextSavePressed(_ sender: Any) {
    addPressed()
    addContextTopConstraint.constant = -44
    addContextSaveButton.isEnabled = false
    addContextField.text = "Add Context"
    addContextField.resignFirstResponder()
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @IBAction func addContextCancelPressed(_ sender: Any) {
    addContextTopConstraint.constant = -44
    addContextField.text = "Add Context"
    addContextSaveButton.isEnabled = false
    addContextField.resignFirstResponder()
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let value = NSString(string: addContextField.text!).replacingCharacters(in: range, with: string)
    // if value.characters.count > 0 {
    if value.count > 0 {
      addContextSaveButton.isEnabled = true
    } else {
      addContextSaveButton.isEnabled = false
    }
    return true
  }
  
  @IBOutlet var addSwipeDown: UISwipeGestureRecognizer!
  @IBOutlet weak var addContextTopConstraint: NSLayoutConstraint!
  @IBOutlet var addSwipe: UISwipeGestureRecognizer!
  
  @IBAction func addSwipeUpGesture(_ sender: Any) {
    addContextField.isEnabled = true
    addContextField.becomeFirstResponder()
    addContextField.text = ""
    addContextField.attributedPlaceholder = NSAttributedString(string: "Add Context", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    addContextSaveButton.isEnabled = false
    if addSwipe.state == .ended {
      self.addContextTopConstraint.constant = -550
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    }
  }
  
  @IBAction func addSwipeDownGesture(_ sender: Any) {
    addContextField.text = "Add Context"
    addContextField.resignFirstResponder()
    addContextField.isEnabled = false
    addContextSaveButton.isEnabled = false
    if addSwipeDown.state == .ended {
      self.addContextTopConstraint.constant = -44
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    }
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    controller.updateCollectionViewDelegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = themeController.backgroundColor
    contextCollectionView.backgroundColor = themeController.backgroundColor
    
    setNavigationItemProperties()
    layoutAddContextView()
    addContextField.isEnabled = false
    if #available(iOS 11.0, *) {
      contextCollectionView?.contentInsetAdjustmentBehavior = .always
    }
    contextCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    addContextField.delegate = self
    contextCollectionView.delegate = self
    contextCollectionView.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  func setNavigationItemProperties() {
    navigationItem.title = "Contexts"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .white
  }
  
  func layoutAddContextView() {
    addView.layer.cornerRadius = 22.0
    addView.layer.shadowColor = UIColor.black.cgColor
    addView.layer.shadowOffset = CGSize(width: 0, height: 3)
    addView.layer.shadowOpacity = 0.6
    contextColorButtonBackView.layer.cornerRadius = 10
    contextColorButtonBackView.layer.shadowColor = UIColor.black.cgColor
    contextColorButtonBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
    contextColorButtonBackView.layer.shadowOpacity = 0.6
    
    var counter = 0
    for button in addContextColorButtons {
      button.backgroundColor = controller.contextColors[counter]
      button.layer.cornerRadius = 12.5
      button.layer.shadowColor = UIColor.black.cgColor
      button.layer.shadowOffset = CGSize(width: 0, height: 3)
      button.layer.shadowOpacity = 0.6
      counter += 1
    }
  }

  
  func addPressed() {
    if addContextField.text != "" {
      if controller.checkIfEditing() {
        controller.setCalendarColor(color: addView.backgroundColor!, context: addContextField.text!)
        let indexPath = controller.returnEditingIndexPath()
        let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
        UIView.animate(withDuration: 0.3) {
          cell.backView.backgroundColor = self.addView.backgroundColor
        }
        controller.editingContext = nil
      } else {
        controller.setCalendarColor(color: addView.backgroundColor!, context: addContextField.text!)
        controller.newCalendarContext = addContextField.text!
      }
      controller.setContextList()
      contextCollectionView.reloadData()
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    themeController = ThemeController()
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    DispatchQueue.main.async() { // update contexts
      self.contextCollectionView.reloadData()
    }
    if themeController.isDarkTheme {
      addContextField.keyboardAppearance = .dark
    } else {
      addContextField.keyboardAppearance = .light
    }
    contextCollectionView.backgroundColor = themeController.backgroundColor
    self.view.backgroundColor = themeController.backgroundColor
    if themeController.isDarkTheme {
      UIApplication.shared.statusBarStyle = .lightContent
    } else {
      UIApplication.shared.statusBarStyle = .default
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
      destination.navigationItem.title = title
    } else if segue.identifier == segueIdentifiers.todayViewSegue {
       let destination = segue.destination as! TodayViewController
      let todayController = TodayController(controller: controller.remindersController)
      destination.todayController = todayController
      navigationController?.navigationBar.barTintColor = colors.darkRed
    } else if segue.identifier == segueIdentifiers.allSegue {
      let destination = segue.destination as! ViewController
      destination.passToDoModelDelegate = self
      destination.remindersController = controller.remindersController
      UIApplication.shared.statusBarStyle = .lightContent
    }
  }
  
  @IBAction func unwindToMainViewFromAll(sender: UIStoryboardSegue) {
    print("unwind")
  }
}

extension MainViewViewController: PassToDoModelToMainDelegate {
  func returnToDoModel(_ controller: RemindersController) {
    print("delegated")
    self.controller = MainViewController(controller: controller)
  }
}

extension MainViewViewController: UpdateCollectionViewDelegate {
  func insertContext(at index: IndexPath) {
    print("insert context delegate")
    contextCollectionView.insertItems(at: [index])
  }
  
  func updateContext() {
    print("updateContext delegate")
    DispatchQueue.main.async {
      self.contextCollectionView.reloadData()
    }
  }
}
