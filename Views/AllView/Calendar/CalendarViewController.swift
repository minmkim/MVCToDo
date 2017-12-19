//
//  CalendarViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

protocol InformEventTableOfCalendarPressDelegate: class {
  func calendarDayPressed(_ Date: String)
  func toDoDroppedOnCalendarDate(_ newDate: String)
}

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarCollectionView: UICollectionView!
  weak var delegate: InformEventTableOfCalendarPressDelegate?
  
  var controller = CalendarController()
  //var themeController = ThemeController()
  var didInitialScroll = false // did user touch calendar yet?
  var previousSelectedCalendayIndexPath: IndexPath?
  var selectedCalendarIndexPath: IndexPath?
  var previousDragIndexPath: IndexPath?
  var displayMonthText = "November" {
    didSet {
      monthLabel.text = displayMonthText
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    monthLabel.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
  //  calendarCollectionView.backgroundColor = themeController.mainThemeColor
    monthLabel.textColor = .white
 //   monthLabel.backgroundColor = themeController.mainThemeColor
    monthLabel.layer.shadowOffset = CGSize(width: 3, height: 0)
    monthLabel.layer.shadowColor = UIColor.black.cgColor
    monthLabel.layer.shadowOpacity = 0.7
      
    calendarCollectionView.delegate = self
    calendarCollectionView.dataSource = self
    calendarCollectionView.dropDelegate = self
  }
  
  override func viewDidLayoutSubviews() {
    // If we haven't done the initial scroll, do it once.
    if !didInitialScroll {
      didInitialScroll = true
      let todayIndexPath = IndexPath(row: 100, section: 0)
      calendarCollectionView.scrollToItem(at: todayIndexPath, at: .left, animated: true)
    }
  }
  
  var tapGestureRecognizer : UITapGestureRecognizer!
  
  override func viewWillAppear(_ animated: Bool) {
    //themeController = ThemeController()
    calendarCollectionView.reloadData()
//    tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.navBarTapped(_:)))
//    self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    print("calendar view disappear")
//    self.navigationController?.navigationBar.removeGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func navBarTapped(_ theObject: AnyObject){
    let todayIndexPath = IndexPath(row: 100, section: 0)
    calendarCollectionView.scrollToItem(at: todayIndexPath, at: .left, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
