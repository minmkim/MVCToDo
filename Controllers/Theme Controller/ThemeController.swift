//
//  ThemeController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/30/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class ThemeController {
  
  var isDarkTheme = false {
    didSet {
      if isDarkTheme == true {
        backgroundColor = .black
        mainTextColor = .white
        headerBackgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
        needShadow = false
        navigationBarColor = .black
        uncheckedCheckmarkIcon = checkMarkAsset.darkUncheckedCircle
      } else {
        backgroundColor = .white
        mainTextColor = .black
        headerBackgroundColor = .groupTableViewBackground
        needShadow = true
        navigationBarColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
        uncheckedCheckmarkIcon = checkMarkAsset.uncheckedCircle
      }
    }
  }
  
  // main red
  let mainThemeColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
  var backgroundColor = UIColor.white
  var mainTextColor = UIColor.black
  var headerBackgroundColor = UIColor.groupTableViewBackground
  var needShadow = true
  var navigationBarColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
  var uncheckedCheckmarkIcon = checkMarkAsset.uncheckedCircle
  
  init() {
    isDarkTheme = UserDefaults.standard.bool(forKey: "DarkTheme")
    if isDarkTheme == true {
      backgroundColor = .black
      mainTextColor = .white
      headerBackgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
      needShadow = false
      navigationBarColor = .black
      uncheckedCheckmarkIcon = checkMarkAsset.darkUncheckedCircle
    } else {
      backgroundColor = .white
      mainTextColor = .black
      headerBackgroundColor = .groupTableViewBackground
      needShadow = true
      navigationBarColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
      uncheckedCheckmarkIcon = checkMarkAsset.uncheckedCircle
    }
  }
  
 
  
}
