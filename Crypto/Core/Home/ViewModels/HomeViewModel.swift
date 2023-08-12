//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 12.08.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    dataService.$allCoins
      .sink { [weak self] coins in
        guard let self = self else { return }
        self.allCoins = coins
      }
      .store(in: &cancellables)
  }
}
