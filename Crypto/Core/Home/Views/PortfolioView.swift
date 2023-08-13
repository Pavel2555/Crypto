//
//  PortfolioView.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 13.08.2023.
//

import SwiftUI

struct PortfolioView: View {
  
  @EnvironmentObject private var vm: HomeViewModel
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantityText: String = ""
  @State private var showCheckMark: Bool = false
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          SearchBarView(searchText: $vm.searchText)
          coinLogoList
          
          if selectedCoin != nil  {
            portfolioInputSection
          }
        }
      }
      .navigationTitle("Edit Portfolio")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavBarButtons
        }
      }
    }
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeVM)
  }
}

extension PortfolioView {
  private var coinLogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 10) {
        ForEach(vm.allCoins) { coin in
          CoinLogoView(coin: coin)
            .frame(width: 75)
            .padding(4)
            .onTapGesture {
              withAnimation(.easeIn) {
                selectedCoin = coin
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                        lineWidth: 1)
            )
        }
      }
      .frame(height: 120)
      .padding(.leading)
    }
  }
  
  private func getCurrentValue() -> Double {
    if let quantity = Double(quantityText) {
      return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    return 0
  }
  
  private var portfolioInputSection: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
        Spacer()
        Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
      }
      Divider()
      HStack {
        Text("Amount holding:")
        Spacer()
        TextField("Ex: 1.4", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      Divider()
      HStack {
        Text("Current value:")
        Spacer()
        Text(getCurrentValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none, value: Bool.random())
    .padding()
    .font(.headline)
    
  }
  
  private var trailingNavBarButtons: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckMark ? 1.0 : 0.0)
      Button {
        saveButtonPressed()
      } label: {
        Text("Save".uppercased())
      }
      .opacity(
        selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ?
        1.0 : 0.0
      )
    }
    .font(.headline)
  }
  
  private func saveButtonPressed() {
    guard let coin = selectedCoin else { return }
    
    //save to portfolio
    
    //show checkmark
    withAnimation(.easeIn) {
      showCheckMark = true
      removeSelectedCoin()
    }
    
    //hide keyboard
    UIApplication.shared.endEditing()
    
    //hide checkmark
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation(.easeOut) {
        showCheckMark = false
      }
    }
  }
  
  private func removeSelectedCoin() {
    selectedCoin = nil
    vm.searchText = ""
  }
}