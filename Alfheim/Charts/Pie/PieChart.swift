//
//  PieChart.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct PieChart: View {
  @ObservedObject var histogram: Histogram<PieUnit>
  private var title: String
  private var legend: String?
  private var symbol: String?

  private var sum: Double {
    histogram.points().reduce(0, +)
  }

  init(histogram: Histogram<PieUnit>,
       title: String,
       legend: String? = nil,
       symbol: String? = nil) {
    self.histogram = histogram
    self.title = title
    self.legend = legend
    self.symbol = symbol
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text(title).font(.system(size: 24, weight: .semibold))
            .foregroundColor(.primary)
          if legend != nil {
            Text(legend!).font(.callout)
              .foregroundColor(.secondary)
              .padding(.leading, 2)
          }
        }
        Spacer()
        Image(systemName: "chart.pie.fill")
      }
      .padding(.bottom, 24)

      Pie(histogram: histogram)
        .aspectRatio(1.0, contentMode: .fit)

      if histogram.isNamed {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(0..<histogram.units.count) { index in
            HStack {
              HStack {
                Text(unit(at: index).symbol)
                  .font(.system(size: 26, weight: .medium))
                Spacer()
              }
              .frame(width: 40)
              VStack(alignment: .leading, spacing: 2) {
                HStack {
                  Text(unit(at: index).label).font(.system(size: 14))
                  Text("\(percent(at: index) * 100, specifier: "%.1f")%")
                    .font(.system(size: 12))
                    .foregroundColor(Color.secondary)
                  Spacer()
                }
                ZStack(alignment: .leading) {
                  GeometryReader { proxy in
                    Capsule().fill(Color(.secondarySystemBackground))
                      .padding(.vertical, 2)
                    progress(at: index, size: proxy.size)
                      .padding(.vertical, 2)
                  }
                }
              }

              Spacer()
              HStack {
                Spacer()
                Text("\(symbol ?? "")\(unit(at: index).value, specifier: "%.1f")")
                  .font(.system(size: 14))
              }
              .frame(width: 72)
            }
            .frame(height: 36)
          }
        }
        .padding(.top, 16)
      }
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color(.systemBackground))
        .shadow(color: Color.shadow, radius: 8)
    )
  }

  private func percent(at index: Int) -> Double {
    unit(at: index).value/sum
  }

  private func unit(at index: Int) -> PieUnit {
    histogram.units[index]
  }

  private func progress(at index: Int, size: CGSize) -> some View {
    let percent = percent(at: index)
    var width = CGFloat(percent) * size.width
    if percent > 0 {
      width = max(width, size.height - 4)
    }
    return Capsule().fill(unit(at: index).color)
      .frame(width: width)
  }
}

#if DEBUG
struct PieChart_Previews : PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      ScrollView {
        PieChart(histogram:  Histogram(values: [("Mon", 8, "a", Color.red), ("Tue", 18, "b", Color.green), ("Wed", 28, "c", Color.blue), ("Thu", 12, "d", Color.brown), ("Fri", 16, "e", Color.pink), ("Sat", 22, "f", Color.cyan), ("Sun", 20, "g", Color.orange)]), title: "Pie", legend: "accounts", symbol: "$")
       }
      .environment(\.colorScheme, colorScheme)
      .previewDisplayName("\(colorScheme)")
      .padding()
    }
    .background(Color(.systemBackground))
  }
}
#endif
