//
//  MainViewViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/25/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class MainViewViewController: UIViewController {
  
  @IBOutlet weak var mainViewTable: UITableView!
  var controller = MainViewController()
  let addContextView: UIView = {
    let view = UIView()
    view.backgroundColor = colors.red
    view.layer.cornerRadius = 22
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
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
    textField.font = UIFont.systemFont(ofSize: 17)
    textField.backgroundColor = .clear
    textField.textColor = .white
    return textField
  }()
  
  let contextLabel: UILabel = {
    let textLabel = UILabel()
    textLabel.font = UIFont.systemFont(ofSize: 17)
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
    mainViewTable.delegate = self
    mainViewTable.dataSource = self
    navigationItem.title = "Due Life"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .white
    
    addContextView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: (self.view.frame.width - 16), height: 80)
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
          circle.backgroundColor = self.controller.returnColor(index)
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
    UIView.animate(withDuration: 0.3) {
      self.addContextView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
    }
    view.endEditing(true)
  }
  
  @objc func gestureSwipeDown(sender: UISwipeGestureRecognizer) {
    UIView.animate(withDuration: 0.3) {
      self.addContextView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
    }
    addContextView.layer.shadowColor = UIColor.clear.cgColor
    view.endEditing(true)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    print("did appear")
    DispatchQueue.main.async() { // update contexts
      self.controller = MainViewController()
      self.mainViewTable.reloadData()
    }
  }
  
  //this does not work, sends wrote title
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ContextItemSegue" {
      let destination = segue.destination as! ContextItemViewController
      let title = controller.returnContextString(controller.selectedContextIndex)
      print(title)
      destination.navigationItem.title = title
      destination.controller.title = title
      print(destination.controller)
    }
  }
  
  func updateConstraints() {
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.centerYAnchor.constraint(equalTo: contextField.centerYAnchor).isActive = true
    addButton.trailingAnchor.constraint(equalTo: addContextView.trailingAnchor, constant: -16.0).isActive = true
    addButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    addButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    
    contextLabel.translatesAutoresizingMaskIntoConstraints = false
    contextLabel.centerYAnchor.constraint(equalTo: contextField.centerYAnchor).isActive = true
    contextLabel.leadingAnchor.constraint(equalTo: addContextView.leadingAnchor, constant: 16.0).isActive = true
    contextLabel.widthAnchor.constraint(equalToConstant: contextLabel.intrinsicContentSize.width).isActive = true
    
    contextField.translatesAutoresizingMaskIntoConstraints = false
    contextField.topAnchor.constraint(equalTo: addContextView.topAnchor, constant: 12.0).isActive = true
    contextField.leadingAnchor.constraint(equalTo: contextLabel.trailingAnchor, constant: 8.0).isActive = true
    contextField.trailingAnchor.constraint(equalTo: addContextView.trailingAnchor, constant: -8.0).isActive = true
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
  
}
