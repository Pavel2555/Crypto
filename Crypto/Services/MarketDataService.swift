//
//  MarketDataService.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 13.08.2023.
//

import Foundation
import Combine

class MarketDataService {
  
  @Published var marketData: MarketDataModel? = nil
  var marketDataSubscription: AnyCancellable?
  
  init() {
    getData()
  }
  
  func getData() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
    
    marketDataSubscription = NetwrokingManager.download(url: url)
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .sink(receiveCompletion: NetwrokingManager.handleCompletion, receiveValue: { [weak self] (globalData) in
        self?.marketData = globalData.data
        self?.marketDataSubscription?.cancel()
      })
  }
}

