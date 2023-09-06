//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 05.09.2023.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coinDetailService = CoinDetailDataService(coin: coin)
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .sink { (returnedCoinDetails) in
        print("RECEIVED COIN DETAIL DATA")
        print(returnedCoinDetails ?? "TEST")
      }
      .store(in: &cancellables)
  }
  
}
