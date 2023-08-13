//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 12.08.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  @Published var statistics: [StatisticModel] = [
  StatisticModel(title: "Title", value: "Value", percentageChange: 1),
  StatisticModel(title: "Title", value: "Value"),
  StatisticModel(title: "Title", value: "Value"),
  StatisticModel(title: "Title", value: "Value", percentageChange: -7)
  ]
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  @Published var searchText: String = ""
  
  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    
    //update allCoins
    dataService.$allCoins
      .sink { [weak self] coins in
        guard let self = self else { return }
        self.allCoins = coins
      }
      .store(in: &cancellables)
    
    $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .combineLatest(dataService.$allCoins)
      .map(filterCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
  }
  
  private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !text.isEmpty else {
      return coins
    }
    
    let lowercasedText = text.lowercased()
    
    return coins.filter({ coin in
      return coin.name.contains(lowercasedText) ||
      coin.symbol.contains(lowercasedText) ||
      coin.id.contains(lowercasedText)
    })
  }
}
