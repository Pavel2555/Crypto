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
  @State private var showLaunchView: Bool = true
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    UITableView.appearance().backgroundColor = UIColor.clear
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        NavigationStack {
          HomeView()
            .navigationBarHidden(true)
        }
        .environmentObject(vm)
        
        ZStack {
          if showLaunchView {
            LaunchView(showLaunchView: $showLaunchView)
              .transition(.move(edge: .leading))
          }
        }
        .zIndex(2.0)
      }
    }
  }
}
