//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 12.08.2023.
//

import Foundation

class HomeViewModel: ObservableObject {
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.allCoins.append(DeveloperPreview.shared.coin)
      self.portfolioCoins.append(DeveloperPreview.shared.coin)
    }
  }
}
