//
//  CustomRepeatViewTableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/14/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class CustomRepeatViewTableViewController: UITableViewController {

  var controller: RepeatController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return controller.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.numberOfRowsPerSection(for: section)
    }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCycleCell", for: indexPath) as! RepeatCycleTableViewCell
        cell.dailyButton.addTarget(self, action: #selector(cycleButtonPress), for:.touchUpInside)
        cell.weeklyButton.addTarget(self, action: #selector(cycleButtonPress), for:.touchUpInside)
        cell.monthlyButton.addTarget(self, action: #selector(cycleButtonPress), for:.touchUpInside)
        cell.yearlyButton.addTarget(self, action: #selector(cycleButtonPress), for:.touchUpInside)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatIntervalCell", for: indexPath) as! RepeatIntervalTableViewCell
        return cell
      }
    } else {
      switch controller.currentCycle {
      case .daily:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCycleCell", for: indexPath)
        return cell
      case .weekly:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatWeeklyCell", for: indexPath) as! RepeatWeeklyTableViewCell
        cell.weekLabel.text = cell.daysOfTheWeek[indexPath.row]
        return cell
      case .monthly:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCalendarCell", for: indexPath) as! RepeatCalendarTableViewCell
        return cell
      case .yearly:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatMonthCell", for: indexPath) as! RepeatMonthTableViewCell
        for indicator in cell.indicatorView {
          indicator.backgroundColor = .white
          indicator.layer.cornerRadius = 20
        }
        for button in cell.monthButton {
          button.addTarget(self, action: #selector(monthButtonPress), for:.touchUpInside)
        }
        return cell
      }
    }
  }
  
   @objc func monthButtonPress(sender: UIButton) {
    let indexPath = IndexPath(row: 0, section: 1)
    let cell = tableView.cellForRow(at: indexPath) as! RepeatMonthTableViewCell
    switch sender.title(for: .normal)! {
    case "Jan":
      if cell.indicatorView[0].backgroundColor != .red {
        cell.indicatorView[0].backgroundColor = .red
      } else {
        cell.indicatorView[0].backgroundColor = .white
      }
    case "Feb":
      if cell.indicatorView[1].backgroundColor != .red {
        cell.indicatorView[1].backgroundColor = .red
      } else {
        cell.indicatorView[1].backgroundColor = .white
      }
    case "Mar":
      if cell.indicatorView[2].backgroundColor != .red {
        cell.indicatorView[2].backgroundColor = .red
      } else {
        cell.indicatorView[2].backgroundColor = .white
      }
    case "Apr":
      if cell.indicatorView[3].backgroundColor != .red {
        cell.indicatorView[3].backgroundColor = .red
      } else {
        cell.indicatorView[3].backgroundColor = .white
      }
    case "May":
      if cell.indicatorView[4].backgroundColor != .red {
        cell.indicatorView[4].backgroundColor = .red
      } else {
        cell.indicatorView[4].backgroundColor = .white
      }
    case "Jun":
      if cell.indicatorView[5].backgroundColor != .red {
        cell.indicatorView[5].backgroundColor = .red
      } else {
        cell.indicatorView[5].backgroundColor = .white
      }
    case "Jul":
      if cell.indicatorView[6].backgroundColor != .red {
        cell.indicatorView[6].backgroundColor = .red
      } else {
        cell.indicatorView[6].backgroundColor = .white
      }
    case "Aug":
      if cell.indicatorView[7].backgroundColor != .red {
        cell.indicatorView[7].backgroundColor = .red
      } else {
        cell.indicatorView[7].backgroundColor = .white
      }
    case "Sep":
      if cell.indicatorView[8].backgroundColor != .red {
        cell.indicatorView[8].backgroundColor = .red
      } else {
        cell.indicatorView[8].backgroundColor = .white
      }
    case "Oct":
      if cell.indicatorView[9].backgroundColor != .red {
        cell.indicatorView[9].backgroundColor = .red
      } else {
        cell.indicatorView[9].backgroundColor = .white
      }
    case "Nov":
      if cell.indicatorView[10].backgroundColor != .red {
        cell.indicatorView[10].backgroundColor = .red
      } else {
        cell.indicatorView[10].backgroundColor = .white
      }
    case "Dec":
      if cell.indicatorView[11].backgroundColor != .red {
        cell.indicatorView[11].backgroundColor = .red
      } else {
        cell.indicatorView[11].backgroundColor = .white
      }
    default:
      print("error")
    }
  }
  
    @objc func cycleButtonPress(sender: UIButton) {
      switch sender.currentTitle {
      case "Daily"?:
        controller.currentCycle = .daily
      case "Weekly"?:
        controller.currentCycle = .weekly
      case "Monthly"?:
        controller.currentCycle = .monthly
      case "Yearly"?:
        controller.currentCycle = .yearly
      default:
        print("sender: \(sender)")
      }
      tableView.reloadData()
    }
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        return 74
      } else {
        return 44.0
      }
    } else {
      switch controller.currentCycle {
      case .daily:
        return 0
      case .weekly:
        return 44
      case .monthly:
        return 200
      case .yearly:
        return 150
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
  
}
