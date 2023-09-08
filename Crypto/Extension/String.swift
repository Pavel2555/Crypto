//
//  String.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 08.09.2023.
//

import Foundation

extension String {
  
  var removingHTMLOccurances: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
  }
}
