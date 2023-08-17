//
//  HapticManager.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 17.08.2023.
//

import SwiftUI

class HapticManager {
  
  static let generator = UINotificationFeedbackGenerator()
  
  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}
