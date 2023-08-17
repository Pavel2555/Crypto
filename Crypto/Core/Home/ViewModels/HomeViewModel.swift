//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 12.08.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  @Published var statistics: [StatisticModel] = []
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  @Published var searchText: String = ""
  
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    //update allCoins
    $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .combineLatest(coinDataService.$allCoins)
      .map(filterCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
    
    //updates market data
    marketDataService.$marketData
      .map(mapGlobalMarketData)
      .sink { [weak self] stats in
        self?.statistics = stats
      }
      .store(in: &cancellables)
    
    //update portfolio coins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map { (coinModels, portfolioEntities) -> [CoinModel] in
        coinModels.compactMap { (coin) -> CoinModel? in
          guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
            return nil
          }
          return coin.updateHoldings(amount: entity.amount)
        }
      }
      .sink { [weak self] coins in
        self?.portfolioCoins = coins
      }
      .store(in: &cancellables)
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
  
  private func mapGlobalMarketData(data: MarketDataModel?) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    
    guard let data else {
      return stats
    }
    
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "24h Volume", value: data.volume)
    let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
    
    stats.append(contentsOf: [
      marketCap,
      volume,
      btcDominance,
      portfolio
    ])
    
    return stats
  }
}
