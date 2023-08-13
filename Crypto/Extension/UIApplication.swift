//
//  UIApplication.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 13.08.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
  
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
