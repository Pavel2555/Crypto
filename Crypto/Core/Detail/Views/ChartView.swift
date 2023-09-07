//
//  ChartView.swift
//  Crypto
//
//  Created by Павел Бескоровайный on 06.09.2023.
//

import SwiftUI

struct ChartView: View {
  
  private let data: [Double]
  private let maxY: Double
  private let minY: Double
  private let lineColor: Color
  private let startingDate: Date
  private let endingDate: Date
  
  @State private var animationPercentage: CGFloat = 0
  
  init(coin: CoinModel) {
    data = coin.sparklineIn7D?.price ?? []
    maxY = data.max() ?? 0
    minY = data.min() ?? 0
    
    let priceChange = (data.last ?? 0) - (data.first ?? 0)
    lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    
    endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
    startingDate = Calendar.current.date(byAdding: .day, value: -7, to: endingDate) ?? Date()
  }
  
  var body: some View {
    VStack {
      chartView
        .frame(height: 200)
        .background(chartBackground)
        .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
      
      chartDateLabels.padding(.horizontal, 4)
    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(.linear(duration: 2)) {
          animationPercentage = 1.0
        }
      }
    }
    
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(coin: dev.coin)
  }
}

extension ChartView {
  
  private var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        for index in data.indices {
          let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
          
          let yAxis = maxY - minY
          
          let yPosition = (1 - (data[index] - minY) / yAxis) * geometry.size.height
          
          if index == 0 {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
          }
          path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
      }
      .trim(from: 0, to: animationPercentage)
      .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor, radius: 10, x: 0, y: 10)
      .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
      .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
      .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
    }
  }
  
  private var chartBackground: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }
  
  private var chartYAxis: some View {
    VStack {
      Text(maxY.formattedWithAbbreviations())
      Spacer()
      Text(((maxY + minY) / 2).formattedWithAbbreviations())
      Spacer()
      Text(minY.formattedWithAbbreviations())
    }
  }
  
  private var chartDateLabels: some View {
    HStack {
      Text(startingDate.asShortDateString())
      Spacer()
      Text(endingDate.asShortDateString())
    }
  }
}
