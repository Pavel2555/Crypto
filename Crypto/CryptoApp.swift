//
//  CryptoApp.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 12.08.2023.
//

import SwiftUI

@main
struct CryptoApp: App {
  
  @StateObject private var vm = HomeViewModel()
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        HomeView()
          .navigationBarHidden(true)
      }
      .environmentObject(vm)
    }
  }
}
