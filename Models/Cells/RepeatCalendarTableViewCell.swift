//
//  RepeatCalendarTableViewCell.swift
//  TestingNewArch
//
//  Created by Min Kim on 12/22/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class RepeatCalendarTableViewCell: UITableViewCell {


  @IBOutlet weak var calendarCollectionView: UICollectionView!
  
  var pressedDays = [Int]()
  override func awakeFromNib() {
        super.awakeFromNib()
    calendarCollectionView.delegate = self
    calendarCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension RepeatCalendarTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = ((calendarCollectionView.frame.width - 100) / 7)
    let height = (calendarCollectionView.frame.height / 5)
    return CGSize(width: width, height: height)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 4 {
      return 3
    } else {
      return 7
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "RepeatCalendarCell", for: indexPath) as! RepeatingCalendarCollectionViewCell
    let number = (indexPath.section * 7) + indexPath.row + 1
    cell.dayNumberLabel.text = String(describing: number)
    cell.indicatorView.layer.cornerRadius = 15
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = calendarCollectionView.cellForItem(at: indexPath) as! RepeatingCalendarCollectionViewCell
    if cell.indicatorView.backgroundColor == .white {
      cell.indicatorView.backgroundColor = .red
      cell.dayNumberLabel.textColor = .white
      pressedDays.append(Int(cell.dayNumberLabel.text!)!)
    } else {
      cell.indicatorView.backgroundColor = .white
      cell.dayNumberLabel.textColor = .black
      guard let index = pressedDays.index(where: {$0 == Int(cell.dayNumberLabel.text!)!}) else {return}
      pressedDays.remove(at: index)
    }
  }
  
}
