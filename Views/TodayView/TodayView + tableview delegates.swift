//
//  File.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/2/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = todayTableView.dequeueReusableCell(withIdentifier: "ContextCell", for: indexPath)
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}
