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
  
  @StateObject private var vm: DetailViewModel
  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  private let spacing: CGFloat = 30
  
  init(coin: CoinModel) {
    _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("")
          .frame(height: 150)
        
        overviewTitle
        Divider()
        overviewGrid
        
        additionalTitle
        Divider()
        additionalGrid
      }
    }
    .padding()
    .navigationTitle(vm.coin.name)
    .ignoresSafeArea()
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      DetailView(coin: dev.coin)
    }
  }
}

extension DetailView {
  
  private var overviewTitle: some View {
    Text("Overview")
      .font(.title)
      .bold()
      .foregroundColor(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var additionalTitle: some View {
    Text("Additional Details")
      .font(.title)
      .bold()
      .foregroundColor(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var overviewGrid: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      pinnedViews: []) {
        ForEach(vm.overviewStatistics) { stat in
          StatisticView(stat: stat)
        }
      }
  }
  
  private var additionalGrid: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      pinnedViews: []) {
        ForEach(vm.additionalStatistics) { stat in
          StatisticView(stat: stat)
        }
      }
  }
}
