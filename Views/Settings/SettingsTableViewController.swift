//
//  SettingsTableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/30/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  var darkTheme = false
  @IBOutlet weak var darkThemeSwitch: UISwitch!
  @IBOutlet weak var darkThemeLabel: UILabel!
  @IBOutlet weak var iapLabel: UILabel!
  
  @IBAction func darkThemeSwitchPressed(_ sender: Any) {
    if darkThemeSwitch.isOn {
      darkTheme = true
      UserDefaults.standard.set(true, forKey: "DarkTheme")
      print(UserDefaults.standard.bool(forKey: "DarkTheme"))
      
      UIView.animate(withDuration: 0.5) {
        self.darkThemeLabel.textColor = .white
        self.iapLabel.textColor = .white
        let cell = self.tableView.visibleCells
        for cell in cell {
          cell.backgroundColor = .black
        }
        self.tableView.backgroundColor = .black
      }
    } else {
      darkTheme = false
      UserDefaults.standard.set(false, forKey: "DarkTheme")
      
      UIView.animate(withDuration: 0.5) {
        self.darkThemeLabel.textColor = .black
        self.iapLabel.textColor = .black
        let cell = self.tableView.visibleCells
        for cell in cell {
          cell.backgroundColor = .white
        }
        self.tableView.backgroundColor = .groupTableViewBackground
      }
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationItem.title = "Settings"
      darkTheme = UserDefaults.standard.bool(forKey: "DarkTheme")
      navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0.427, blue: 0.397, alpha: 1)
      if darkTheme == false {
        darkThemeSwitch.isOn = false
        self.darkThemeLabel.textColor = .black
        self.iapLabel.textColor = .black
        
        self.tableView.backgroundColor = .groupTableViewBackground
      } else {
        darkThemeSwitch.isOn = true
        self.darkThemeLabel.textColor = .white
        self.iapLabel.textColor = .white
        
        self.tableView.backgroundColor = .black
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      if darkTheme == false {
        let cell = self.tableView.visibleCells
        for cell in cell {
          cell.backgroundColor = .white
        }
      } else {
        let cell = self.tableView.visibleCells
        for cell in cell {
          cell.backgroundColor = .black
        }
      }
      return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 1
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

}
