//
//  CalendarViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var calendarCollectionView: UICollectionView!
  
  var controller: CalendarController = CalendarController()
  var didInitialScroll = false // did user touch calendar yet?
  var previousSelectedCalendayIndexPath: IndexPath?
  var selectedCalendarIndexPath: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    controller.test()
    calendarCollectionView.delegate = self
    calendarCollectionView.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  override func viewDidLayoutSubviews() {
    // If we haven't done the initial scroll, do it once.
    if !didInitialScroll {
      didInitialScroll = true
      print("here")
      let todayIndexPath = IndexPath(row: 100, section: 0)
      calendarCollectionView.scrollToItem(at: todayIndexPath, at: .left, animated: true)
    }
  }

  
  
  var tapGestureRecognizer : UITapGestureRecognizer!
  
  override func viewWillAppear(_ animated: Bool) {
    tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.navBarTapped(_:)))
    self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.navigationBar.removeGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func navBarTapped(_ theObject: AnyObject){
    let todayIndexPath = IndexPath(row: 100, section: 0)
    calendarCollectionView.scrollToItem(at: todayIndexPath, at: .left, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
