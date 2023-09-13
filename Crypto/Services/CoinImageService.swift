//
//  CoinImageService.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 13.08.2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
  
  @Published var image: UIImage? = nil
  
  private var imageSubscription: AnyCancellable?
  private let coin: CoinModel
  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"
  private let imageName: String
  
  init(coin: CoinModel) {
    self.coin = coin
    self.imageName = coin.id
    getCoinImage()
  }
  
  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
      image = savedImage
      print("Retrieve image from File Manager!")
    } else {
      downloadCoinImage()
      print("Downloading image now")
    }
  }
  
  private func downloadCoinImage() {
    guard let url = URL(string: coin.image) else { return }
    
    imageSubscription = NetwrokingManager.download(url: url)
      .tryMap({ (data) -> UIImage? in
        return UIImage(data: data)
      })
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetwrokingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
        guard let self, let returnedImage else { return }
        self.image = returnedImage
        self.imageSubscription?.cancel()
        self.fileManager.saveImage(image: returnedImage, imageName: self.imageName, folderName: self.folderName)
      })
  }
}
