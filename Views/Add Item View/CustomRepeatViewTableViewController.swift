//
//  CustomRepeatViewTableViewController.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/14/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class CustomRepeatViewTableViewController: UITableViewController {

  
  //first row
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var frequencyDisplayLabel: UILabel!
  
  // second row
  @IBOutlet weak var intervalLabel: UILabel!
  @IBOutlet weak var intervalDisplayLabel: UILabel!
  @IBOutlet weak var intervalStepper: UIStepper!
  @IBAction func intervalStepperPress(_ sender: Any) {
    if intervalStepper.value == 1 {
      switch controller.currentCycle {
      case .daily:
        intervalDisplayLabel.text = "Every Day"
      case .weekly:
        intervalDisplayLabel.text = "Every Week"
      case .monthly:
        intervalDisplayLabel.text = "Every Month"
      case .yearly:
        intervalDisplayLabel.text = "Every Year"
      }
    } else {
      switch controller.currentCycle {
      case .daily:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Days"
      case .weekly:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Weeks"
      case .monthly:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Months"
      case .yearly:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Years"
      }
    }
  }
  
  //days of week
  var pressedDaysOfWeek = [Int]()
  
  //calendar
  var controller: RepeatController!
  var pressedDays = [Int]()
  
  //months
  var pressedMonths = [Int]()
  @IBOutlet var monthButton: [UIButton]!
  @IBOutlet var monthIndicatorView: [UIView]!
  @IBAction func monthButtonPressed(_ sender: UIButton) {
        switch sender.title(for: .normal)! {
        case "Jan":
          if monthIndicatorView[0].backgroundColor != .red {
            pressedMonths.append(1)
            monthIndicatorView[0].backgroundColor = .red
          } else {
            monthIndicatorView[0].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 1}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Feb":
          if monthIndicatorView[1].backgroundColor != .red {
            pressedMonths.append(2)
            monthIndicatorView[1].backgroundColor = .red
          } else {
            monthIndicatorView[1].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 2}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Mar":
          if monthIndicatorView[2].backgroundColor != .red {
            pressedMonths.append(3)
            monthIndicatorView[2].backgroundColor = .red
          } else {
            monthIndicatorView[2].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 3}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Apr":
          if monthIndicatorView[3].backgroundColor != .red {
            pressedMonths.append(4)
            monthIndicatorView[3].backgroundColor = .red
          } else {
            monthIndicatorView[3].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 4}) else {return}
            pressedMonths.remove(at: index)
          }
        case "May":
          if monthIndicatorView[4].backgroundColor != .red {
            pressedMonths.append(5)
            monthIndicatorView[4].backgroundColor = .red
          } else {
            monthIndicatorView[4].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 5}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Jun":
          if monthIndicatorView[5].backgroundColor != .red {
            pressedMonths.append(6)
            monthIndicatorView[5].backgroundColor = .red
          } else {
            monthIndicatorView[5].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 6}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Jul":
          if monthIndicatorView[6].backgroundColor != .red {
            pressedMonths.append(7)
            monthIndicatorView[6].backgroundColor = .red
          } else {
            monthIndicatorView[6].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 7}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Aug":
          if monthIndicatorView[7].backgroundColor != .red {
            pressedMonths.append(8)
            monthIndicatorView[7].backgroundColor = .red
          } else {
            monthIndicatorView[7].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 8}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Sep":
          if monthIndicatorView[8].backgroundColor != .red {
            pressedMonths.append(9)
            monthIndicatorView[8].backgroundColor = .red
          } else {
            monthIndicatorView[8].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 9}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Oct":
          if monthIndicatorView[9].backgroundColor != .red {
            pressedMonths.append(10)
            monthIndicatorView[9].backgroundColor = .red
          } else {
            monthIndicatorView[9].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 10}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Nov":
          if monthIndicatorView[10].backgroundColor != .red {
            pressedMonths.append(11)
            monthIndicatorView[10].backgroundColor = .red
          } else {
            monthIndicatorView[10].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 11}) else {return}
            pressedMonths.remove(at: index)
          }
        case "Dec":
          if monthIndicatorView[11].backgroundColor != .red {
            pressedMonths.append(12)
            monthIndicatorView[11].backgroundColor = .red
          } else {
            monthIndicatorView[11].backgroundColor = .white
            guard let index = pressedMonths.index(where: {$0 == 12}) else {return}
            pressedMonths.remove(at: index)
          }
        default:
          print("error")
        }
  }
  
  
  
  @IBOutlet weak var calendarCollectionView: UICollectionView!
  override func viewDidLoad() {
        super.viewDidLoad()
    let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    self.navigationItem.rightBarButtonItem = saveButton
    calendarCollectionView.delegate = self
    calendarCollectionView.dataSource = self
    intervalStepper.minimumValue = 1
    print(controller.repeatCustomRule)
    if controller.repeatCycleInterval == 1 {
      switch controller.currentCycle {
      case .daily:
        intervalDisplayLabel.text = "Every Day"
      case .weekly:
        intervalDisplayLabel.text = "Every Week"
      case .monthly:
        intervalDisplayLabel.text = "Every Month"
      case .yearly:
        intervalDisplayLabel.text = "Every Year"
      }
    } else {
      intervalStepper.value = Double(controller.repeatCycleInterval ?? 1)
      switch controller.currentCycle {
      case .daily:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Days"
      case .weekly:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Weeks"
      case .monthly:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Months"
      case .yearly:
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Years"
      }
    }
    
    if controller.repeatCustomRule != nil {
      switch controller.repeatCustomRule! {
      case .daysOfTheWeek:
        pressedDaysOfWeek = controller.repeatCustomNumber
        for number in pressedDaysOfWeek {
          let index = IndexPath(row: (number - 1), section: 1)
          let cell = tableView.cellForRow(at: index)
          cell?.accessoryType = .checkmark
        }
      case .monthsOfTheYear:
        pressedMonths = controller.repeatCustomNumber
        for number in pressedMonths {
          monthIndicatorView[number].backgroundColor = .red
        }
      default:
        print("error")
      }
      tableView.beginUpdates()
      tableView.endUpdates()
    }
    for indicator in monthIndicatorView {
      indicator.layer.cornerRadius = 20
    }
  }

  @objc func save() {
    switch controller.currentCycle {
    case .daily:
      controller.savePressed(repeatCycleInterval: Int(intervalStepper.value), repeatCustomNumber: [])
    case .weekly:
      controller.savePressed(repeatCycleInterval: Int(intervalStepper.value), repeatCustomNumber: pressedDaysOfWeek)
    case .monthly:
      controller.savePressed(repeatCycleInterval: Int(intervalStepper.value), repeatCustomNumber: pressedDays)
    case .yearly:
      controller.savePressed(repeatCycleInterval: Int(intervalStepper.value), repeatCustomNumber: pressedMonths)
    }
    performSegue(withIdentifier: segueIdentifiers.unwindWithCustomRepeatSegue, sender: nil)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  @IBOutlet weak var yearlyButton: UIButton!
  @IBOutlet weak var monthlyButton: UIButton!
  @IBOutlet weak var weeklyButton: UIButton!
  @IBOutlet weak var dailyButton: UIButton!
  
  @IBAction func cycleButtonPressed(_ sender: UIButton) {
    switch sender.currentTitle {
    case "Daily"?:
      controller.currentCycle = .daily
      frequencyDisplayLabel.text = "Daily"
      if intervalStepper.value == 1 {
        intervalDisplayLabel.text = "Every Day"
      } else {
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Days"
      }
    case "Weekly"?:
      print(pressedDaysOfWeek)
      controller.currentCycle = .weekly
      frequencyDisplayLabel.text = "Weekly"
      if intervalStepper.value == 1 {
        intervalDisplayLabel.text = "Every Week"
      } else {
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Weeks"
      }
    case "Monthly"?:
      print(pressedDays)
      controller.currentCycle = .monthly
      frequencyDisplayLabel.text = "Monthly"
      if intervalStepper.value == 1 {
        intervalDisplayLabel.text = "Every Month"
      } else {
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Months"
      }
    case "Yearly"?:
      print(pressedMonths)
      controller.currentCycle = .yearly
      frequencyDisplayLabel.text = "Yearly"
      if intervalStepper.value == 1 {
        intervalDisplayLabel.text = "Every Year"
      } else {
        intervalDisplayLabel.text = "Every \(Int(intervalStepper.value)) Years"
      }
    default:
      print("sender: \(sender)")
    }
    tableView.beginUpdates()
    tableView.endUpdates()
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
        switch indexPath.row {
        case 0...6:
          return 44.0
        default:
          return 0
        }
      case .monthly:
        switch indexPath.row {
        case 0...6:
          return 0.0
        case 7:
          return 200.0
        default:
          return 0
        }
      case .yearly:
        switch indexPath.row {
        case 0...6:
          return 0.0
        case 7:
          return 0
        default:
          return 150.0
        }
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
    if indexPath.section == 1 &&  0...6 ~= indexPath.row {
      if cell?.accessoryType == .checkmark {
        cell?.accessoryType = .none
        guard let index = pressedDaysOfWeek.index(where: {$0 == indexPath.row}) else {return}
        pressedDaysOfWeek.remove(at: index)
      } else {
        pressedDaysOfWeek.append(indexPath.row)
        cell?.accessoryType = .checkmark
      }
    }
  }
  
}
