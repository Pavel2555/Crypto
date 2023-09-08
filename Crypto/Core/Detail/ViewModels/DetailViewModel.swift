//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 05.09.2023.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  
  @Published var overviewStatistics: [StatisticModel] = []
  @Published var additionalStatistics: [StatisticModel] = []
  @Published var coinDescription: String? = nil
  @Published var webSiteURL: String? = nil
  @Published var redditURL: String? = nil
  
  @Published var coin: CoinModel
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailService = CoinDetailDataService(coin: coin)
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map(mapDataToStatistics)
      .sink { [weak self] (returnedArrays) in
        self?.overviewStatistics = returnedArrays.overview
        self?.additionalStatistics = returnedArrays.additional
      }
      .store(in: &cancellables)
    
    coinDetailService.$coinDetails
      .sink { [weak self] (returnedCoinDetails) in
        self?.coinDescription = returnedCoinDetails?.readableDescription
        self?.webSiteURL = returnedCoinDetails?.links?.homepage?.first
        self?.redditURL = returnedCoinDetails?.links?.subredditURL
      }
      .store(in: &cancellables)
  }
  
  private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
    let overViewArray = createOverviewArray(coinModel: coinModel)
    let additionalArray = createAdditioanlArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
    return (overViewArray, additionalArray)
  }
  
  private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
    let price = coinModel.currentPrice.asCurrencyWith6Decimals()
    let pricePercentChange = coinModel.priceChangePercentage24H
    let priceStat = StatisticModel(title: "Current price", value: price, percentageChange: pricePercentChange)
    
    let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
    let marketCapPercentChange = coinModel.marketCapChangePercentage24H
    let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
    
    let rank = "\(coinModel.rank)"
    let rankStat = StatisticModel(title: "Ranl", value: rank)
    
    let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
    let volumeStat = StatisticModel(title: "Volume", value: volume)
    
    let overviewArray: [StatisticModel] = [
      priceStat, marketCapStat, rankStat, volumeStat
    ]
    
    return overviewArray
  }
  
  private func createAdditioanlArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
    //additional
    let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let highStat = StatisticModel(title: "24 h High", value: high)
    
    let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let lowStat = StatisticModel(title: "24 h Low", value: low)
    
    let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
    let pricePercentagechange = coinModel.priceChangePercentage24H
    let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentagechange)
    
    let marketCapChange = "$" + (coinModel.marketCapChangePercentage24H?.formattedWithAbbreviations() ?? "")
    let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
    let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange)
    
    let blocktime = coinDetailModel?.blockTimeInMinutes ?? 0
    let blockTimeString = blocktime == 0 ? "n/a" : "\(blocktime)"
    let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
    
    let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
    let hashingStat = StatisticModel(title: "Hashing Algoritm", value: hashing)
    
    let additionalArray: [StatisticModel] = [
      highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
    ]
    
    return additionalArray
  }  
}
