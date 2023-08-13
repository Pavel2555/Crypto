//
//  CoinDataService.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 12.08.2023.
//

import Foundation
import Combine


class CoinDataService {
  
  @Published var allCoins: [CoinModel] = []
  var coinSubscription: AnyCancellable?
  
  init() {
    getCoins()
  }
  
  private func getCoins() {
    
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en") else { return }
    
    coinSubscription = NetwrokingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: JSONDecoder())
      .sink(receiveCompletion: NetwrokingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
        self?.allCoins = returnedCoins
        self?.coinSubscription?.cancel()
      })
    
  }
}
