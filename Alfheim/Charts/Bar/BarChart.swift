//
//  BarChart.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct BarChart: View {
  @ObservedObject var histogram: Histogram<Dimension>
  var title: String
  var legend: String?

  private var specifier: String

  @State private var touchLocation: CGPoint = .zero
  @State private var currentValue: Value = 0
  @State private var showsValue: Bool = false

  init(histogram: Histogram<Dimension>,
       title: String,
       legend: String? = nil,
       specifier: String = "%.1f") {
    self.histogram = histogram
    self.title = title
    self.legend = legend
    self.specifier = specifier
  }

  init(data: [(String, Double)],
       title: String,
       legend: String? = nil,
       specifier: String = "%.1f") {
    self.init(histogram: Histogram(values: data),
              title: title,
              legend: legend,
              specifier: specifier)
  }

  init(data: [(String, Int)],
       title: String,
       legend: String? = nil,
       specifier: String = "%.1f") {
    self.init(data: data.map { ($0, Double($1)) },
              title: title,
              legend: legend,
              specifier: specifier)
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(.systemBackground))
          .shadow(color: Color.shadow, radius: 8)
        VStack(alignment: .leading, spacing: 2) {
          HStack {
            VStack(alignment: .leading, spacing: 8) {
              if !showsValue {
                Text(title)
                  .font(.system(size: 24, weight: .semibold))
                  .foregroundColor(.primary)

                if legend != nil {
                  Text(legend!).font(.callout)
                    .foregroundColor(.secondary)
                }
              } else {
                Text("\(currentValue, specifier: specifier)")
                  .font(.system(size: 41, weight: .bold))
                  .foregroundColor(.primary)
              }
            }
            Spacer()
            Image(systemName: "waveform.path.ecg")
          }
          .transition(.opacity.animation(.easeIn(duration: 0.1)))
          .frame(height: 54, alignment: .center)
          .padding(.bottom, 24)

          GeometryReader { geometry in
            Bar(histogram: histogram)
          }
          .gesture(DragGesture()
            .onChanged { value in
              touchLocation = value.location
              showsValue = true
              handleTouch(to: value.location, in: geometry.frame(in: .local).size)
            }
            .onEnded { value in
              showsValue = false
            }
          )

          if histogram.isNamed {
            GeometryReader { geometry in
              HStack(alignment: .bottom, spacing: CGFloat(geometry.size.width) / CGFloat(3 * (histogram.units.count - 1))) {
                ForEach(histogram.units, id: \.symbol) { unit in
                  Text(unit.symbol)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity)
                }
              }
            }
            .frame(height: 24)
            .padding(.top, 4)
          }
        }
        .padding(20)
      }
    }
  }
}

extension BarChart {
  @discardableResult
  private func handleTouch(to location: CGPoint, in frame: CGSize) -> Int {
    let points = histogram.points()
    let step = frame.width / CGFloat(points.count)
    let idx = max(0, min(histogram.points().count - 1, Int(location.x / step)))
    currentValue = points[idx]
    return idx
  }
}

#if DEBUG
struct BarChart_Previews : PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
      GeometryReader { geometry in
        BarChart(data: [("A", 21), ("B", 9800), ("C", 0), ("D", 22)], title: "Bar", legend: "chart")
      }
      .environment(\.colorScheme, colorScheme)
      .previewDisplayName("\(colorScheme)")
    }
    .previewLayout(.sizeThatFits)
    .background(Color(.systemBackground))
    .padding(10)
  }
}
#endif
