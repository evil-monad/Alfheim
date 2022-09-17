//
//  CompositionView.swift
//  CompositionView
//
//  Created by alex.huo on 2021/8/8.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct CompositionView: View {
  var histogram: Histogram<PieUnit>
  init(units: [PieUnit]) {
    self.histogram = Histogram(units: units)
  }

  var body: some View {
    VStack(spacing: 24) {
      titleView

      HStack(spacing: 20) {
        Pie(histogram: histogram)
          .aspectRatio(1.0, contentMode: .fit)

        LegendView(histogram: histogram)
      }
      .padding(.horizontal, 4)
    }
    .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 16, trailing: 16))
  }

  private var titleView: some View {
    HStack {
      Text("Composition").font(.headline)
      Spacer()
      Image(systemName: "chart.pie.fill")
    }
  }

  struct LegendView: View {
    @ObservedObject var histogram: Histogram<PieUnit>
    let showsValue: Bool = false

    var body: some View {
      VStack(alignment: .leading, spacing: 6) {
        ForEach(0..<histogram.units.count, id: \.self) { index in
          HStack(spacing: 0) {
            HStack {
              Text(unit(at: index).symbol)
                .font(.title3)
              Spacer()
            }
            .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
              HStack {
                Text(unit(at: index).label).font(.caption)
                Text((percent(at: index)).formatted(.percent.precision(.fractionLength(1))))
                  .font(.caption2)
                  .foregroundColor(Color.secondary)
                Spacer()
              }

              ZStack(alignment: .leading) {
                GeometryReader { proxy in
                  Capsule().fill(Color(.secondarySystemBackground))
                    .padding(.vertical, 2)
                  progressView(at: index, size: proxy.size)
                    .padding(.vertical, 2)
                }
              }
            }

            if showsValue {
              Spacer()
              HStack {
                Spacer()
                Text(unit(at: index).value.formatted(.number.precision(.fractionLength(1))))
                  .font(.footnote)
              }
              .frame(width: 40)
            }
          }
          .frame(height: 28)
        }
      }
    }

    private var sum: Double {
      histogram.points().reduce(0, +)
    }

    private func percent(at index: Int) -> Double {
      unit(at: index).value/sum
    }

    private func unit(at index: Int) -> PieUnit {
      histogram.units[index]
    }

    private func progressView(at index: Int, size: CGSize) -> some View {
      let percent = percent(at: index)
      var width = CGFloat(percent) * size.width
      if percent > 0 {
        width = max(width, size.height - 4)
      }
      return Capsule().fill(unit(at: index).color)
        .frame(width: width)
    }
  }
}
#if DEBUG

extension Color {
  static func color(at index: Int) -> Color {
    let all: [Color] = [.red, .green, .blue, .orange, .yellow, .pink, .purple]
    let i = index % all.count
    return all[i]
  }

  static var random: Color {
    return Color.color(at: Int.random(in: 0..<7))
  }
}

struct Legend_Preview: PreviewProvider {
  static var previews: some View {
    CompositionView.LegendView(histogram: Histogram(values: [("Sat", 0, "A", Color.random), ("Sun", 1, "A", Color.random), ("Mon", 18, "A", Color.random), ("Tue", 28, "A", Color.random), ("Wed", 36, "A", Color.random), ("Thu", 23, "A", Color.random), ("Fri", 100, "A", Color.random)]))
  }
}
#endif
