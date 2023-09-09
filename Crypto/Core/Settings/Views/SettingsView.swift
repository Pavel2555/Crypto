//
//  SettingsView.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 08.09.2023.
//

import SwiftUI

struct SettingsView: View {
  
  let defaultURL = URL(string: "https://www.google.com/?client=safari")!
  let youtubeURL = URL(string: "htpps://www.youtube.com/c/swiftfulthinking")!
  let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
  let coingeckoURL = URL(string: "https://www.coingecko.com")!
  let githubURL = URL(string: "https://github.com/PavloBezkorovainyi/")!
  
  var body: some View {
    NavigationStack {
      List {
        
        coinGeckoSection
        developerSection
        swiftfulThinkingSection
        applicationSection
      }
      .listStyle(.grouped)
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton()
        }
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

extension SettingsView {
  
  private var swiftfulThinkingSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("This app was made by following a @Swiftfulthinking course on YouTube. It uses MVVM Architecture, Combine and CoreData!")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
      }
      .padding(.vertical)
      Link("Youtube 🥳", destination: youtubeURL)
      Link("Support his coffee addiction ☕️", destination: coffeeURL)
    } header: {
      Text("SwiftfulThinking")
    }
  }
  
  private var coinGeckoSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("The cryptocurrency data that used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
      }
      .padding(.vertical)
      Link("Visit CoinGecko 🦎", destination: coingeckoURL)
    } header: {
      Text("CoinGecko")
    }
  }
  
  private var developerSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image(systemName: "macbook.and.iphone")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("This app was developer by Pavlo Bezkorovainyi. It uses SwiftUI and is written 100% on Swift.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
      }
      .padding(.vertical)
      Link("GitHub 🤙", destination: githubURL)
    } header: {
      Text("Developer")
    }
  }
  
  private var applicationSection: some View {
    Section {
      Link("Terms of Service", destination: defaultURL)
      Link("Privacy Policy", destination: defaultURL)
      Link("Company Website", destination: defaultURL)
      Link("Learn More", destination: defaultURL)
    }
  }
}
