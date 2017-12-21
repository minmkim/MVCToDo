//
//  MainViewViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class MainViewViewController: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var contextCollectionView: UICollectionView!
  @IBOutlet weak var mainViewTable: UITableView!
  var controller = MainViewController()
  var themeController = ThemeController()
  let addContextView: UIView = {
    let view = UIView()
    view.backgroundColor = colors.red
    view.layer.cornerRadius = 22
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 4)
    view.layer.shadowOpacity = 0.6
    return view
  }()
  
  let addButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "PlusIcon"), for: .normal)
    button.addTarget(self,action:#selector(addPressed), for:.touchUpInside)
    return button
  }()
  
  let contextField: UITextField = {
    let textField = UITextField()
    textField.font = UIFont.systemFont(ofSize: 20)
    textField.backgroundColor = .clear
    textField.textColor = .white
    return textField
  }()
  
  let contextLabel: UILabel = {
    let textLabel = UILabel()
    textLabel.font = UIFont.systemFont(ofSize: 20)
    textLabel.text = "Context:"
    textLabel.textColor = .white
    return textLabel
  }()
  
  let viewForStack: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 10
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowOpacity = 0.6
    return view
  }()
  
  let verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    stackView.spacing = 6
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = themeController.backgroundColor
    contextCollectionView.backgroundColor = themeController.backgroundColor
    navigationItem.title = "Contexts"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .white
    addContextView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: (self.view.frame.width - 16), height: 200)
    
    let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureSwipeDown))
    gesture.delegate = self
    gesture.direction = .down
    addContextView.addGestureRecognizer(gesture)
    self.view.addSubview(addContextView)
    addContextView.addSubview(contextField)
    addContextView.addSubview(contextLabel)
    addContextView.addSubview(addButton)
    addContextView.addSubview(viewForStack)
    viewForStack.addSubview(verticalStackView)
    updateConstraints()
    if #available(iOS 11.0, *) {
      contextCollectionView?.contentInsetAdjustmentBehavior = .always
    }
    DispatchQueue.main.async {
      var index = -1
      for _ in 0...2 {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.alignment = .center
        self.verticalStackView.addArrangedSubview(horizontalStackView)
        
        for _ in 0...5 {
          index += 1
          let circle = UIButton()
          circle.backgroundColor = self.controller.contextColors[index]
          circle.heightAnchor.constraint(equalToConstant: 25).isActive = true
          circle.widthAnchor.constraint(equalToConstant: 25).isActive = true
          circle.layer.cornerRadius = 12.5
          circle.layer.shadowColor = UIColor.black.cgColor
          circle.layer.shadowOffset = CGSize(width: 0, height: 2)
          circle.layer.shadowOpacity = 0.6
          horizontalStackView.addArrangedSubview(circle)
          circle.addTarget(self,action:#selector(self.touchCircle), for:.touchUpInside)
        }
      }
    }
//    DispatchQueue.global().async {
//      let storyboard = UIStoryboard(name: "Main", bundle: nil)
//      self.allViewController = storyboard.instantiateViewController(withIdentifier: "AllViewController") as? ViewController
//      self.allViewController?.toDoModelController = self.controller.toDoModelController
//      self.allViewController?.passToDoModelDelegate = self
//    }
    contextCollectionView.delegate = self
    contextCollectionView.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  @objc func touchCircle(sender:UIButton) {
    UIView.animate(withDuration: 0.3, animations: {
      let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      sender.transform = scaleTransform
    }) { (_) in
      UIView.animate(withDuration: 0.3, animations: {
        sender.transform = CGAffineTransform.identity
      })
    }
    UIView.animate(withDuration: 0.7) {
      self.addContextView.backgroundColor = sender.backgroundColor
    }
  }
  
  @objc func addPressed(sender:UIButton) {
    if contextField.text != "" {
      UIView.animate(withDuration: 0.3) {
        self.addContextView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
      }
      view.endEditing(true)
      if controller.checkIfEditing() {
        controller.addContextSavedPressed(color: addContextView.backgroundColor!, context: contextField.text!)
        let indexPath = controller.returnEditingIndexPath()
        let cell = contextCollectionView.cellForItem(at: indexPath) as! ContextItemCollectionViewCell
        UIView.animate(withDuration: 0.3) {
          cell.backView.backgroundColor = self.addContextView.backgroundColor
        }
        controller.editingContext = nil
      } else {
        controller.addContextSavedPressed(color: addContextView.backgroundColor!, context: contextField.text!)
        //  let newIndexPath = controller.returnNewIndexPath(contextField.text!)
        //    contextCollectionView.insertItems(at: [newIndexPath])
      }
      controller.setContextList()
      contextCollectionView.reloadData()
    }
    
  }
  
  @objc func gestureSwipeDown(sender: UISwipeGestureRecognizer) {
    if controller.checkIfEditing() {
      controller.editingContext = nil
    }
    UIView.animate(withDuration: 0.3) {
      self.addContextView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
    }
    view.endEditing(true)
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
   //   self.controller = MainViewController()
      self.contextCollectionView.reloadData()
    }
    if themeController.isDarkTheme {
      contextField.keyboardAppearance = .dark
    } else {
      contextField.keyboardAppearance = .light
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
  
  //this does not work, sends wrote title
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ContextItemSegue" {
      let destination = segue.destination as! ContextItemViewController
      let title = controller.returnContextString(controller.selectedContextIndex)
      destination.navigationItem.title = title
      destination.controller.title = title
    } else if segue.identifier == segueIdentifiers.todayViewSegue {
       let destination = segue.destination as! TodayViewController
      let todayController = TodayController(controller: controller.remindersController)
      destination.todayController = todayController
      navigationController?.navigationBar.barTintColor = controller.returnColor("Today")
    } else if segue.identifier == segueIdentifiers.allSegue {
      let destination = segue.destination as! ViewController
      destination.passToDoModelDelegate = self
      destination.remindersController = controller.remindersController
      UIApplication.shared.statusBarStyle = .lightContent
      
    }
  }
  
  func updateConstraints() {
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.centerYAnchor.constraint(equalTo: contextField.centerYAnchor).isActive = true
    addButton.trailingAnchor.constraint(equalTo: addContextView.trailingAnchor, constant: -16.0).isActive = true
    addButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    addButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    
    contextLabel.translatesAutoresizingMaskIntoConstraints = false
    contextLabel.topAnchor.constraint(equalTo: addContextView.topAnchor, constant: 12.0).isActive = true
    contextLabel.leadingAnchor.constraint(equalTo: addContextView.leadingAnchor, constant: 16.0).isActive = true
    contextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contextLabel.intrinsicContentSize.width).isActive = true
    contextLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    
    contextField.translatesAutoresizingMaskIntoConstraints = false
    contextField.topAnchor.constraint(equalTo: addContextView.topAnchor, constant: 12.0).isActive = true
    contextField.leadingAnchor.constraint(equalTo: contextLabel.trailingAnchor, constant: 8.0).isActive = true
    contextField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8.0).isActive = true
    contextField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    
    viewForStack.translatesAutoresizingMaskIntoConstraints = false
    viewForStack.topAnchor.constraint(equalTo: contextField.bottomAnchor, constant: 8.0).isActive = true
    viewForStack.leadingAnchor.constraint(equalTo: addContextView.leadingAnchor, constant: 16).isActive = true
    viewForStack.trailingAnchor.constraint(equalTo: addContextView.trailingAnchor, constant: -16).isActive = true
    viewForStack.bottomAnchor.constraint(equalTo: addContextView.bottomAnchor, constant: -16).isActive = true
    
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    verticalStackView.topAnchor.constraint(equalTo: viewForStack.topAnchor, constant: 8.0).isActive = true
    verticalStackView.leadingAnchor.constraint(equalTo: viewForStack.leadingAnchor, constant: 8.0).isActive = true
    verticalStackView.trailingAnchor.constraint(equalTo: viewForStack.trailingAnchor, constant: -8.0).isActive = true
    verticalStackView.bottomAnchor.constraint(equalTo: viewForStack.bottomAnchor, constant: -8.0).isActive = true
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
