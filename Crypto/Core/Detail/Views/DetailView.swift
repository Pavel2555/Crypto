//
//  DetailView.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 17.08.2023.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: CoinModel?
  
  var body: some View {
    ZStack {
      if let coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  
  let coin: CoinModel
  
  init(coin:CoinModel) {
    self.coin = coin
    print("initializng detail vew for \(coin.name)")
    
  }
  
  var body: some View {
    Text(coin.name)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
