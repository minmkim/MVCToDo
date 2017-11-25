//
//  HapticFeedbackVariableChange.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/24/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import Foundation
import AudioToolbox.AudioServices
import UIKit

// haptic feedback for calendar

class VariableChange {
  let generator = UISelectionFeedbackGenerator()
  let peek = SystemSoundID(1519)
  var variable = [IndexPath]() {
    willSet {
      generator.prepare()
      AudioServicesPlaySystemSound(peek)
      generator.selectionChanged()
    }
  }
}
