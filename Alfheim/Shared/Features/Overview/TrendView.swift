//
//  TrendView.swift
//  TrendView
//
//  Created by alex.huo on 2021/8/8.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import CombineSchedulers

struct TrendView: View {
  var histogram: Histogram<Dimension>
  let currency: Currency

  init(units: [Dimension], currency: Currency) {
    self.histogram = Histogram(units: units)
    self.currency = currency
  }

  init(histogram: Histogram<Dimension>, currency: Currency) {
    self.histogram = histogram
    self.currency = currency
  }

  @State private var touchLocation: CGPoint = .zero
  @State private var showsIndicator: Bool = false
  @State private var currentValue: Double = 0

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 14) {
        titleView

        GeometryReader { geometry in
          Line(histogram: histogram, frame: .constant(geometry.frame(in: .local)), touchLocation: $touchLocation, showsIndicator: $showsIndicator)
        }
        .offset(x: 0, y: 0)
        .gesture(
          DragGesture()
            .onChanged { value in
              touchLocation = value.location
              showsIndicator = true
              handleTouch(to: value.location, in: geometry.frame(in: .local).size)
            }
            .onEnded { value in
              showsIndicator = false
            }
        )
        .padding(.horizontal, 6)

        LegendView(histogram: histogram)
          .padding(.horizontal, -6)
      }
    }
    .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 16))
  }

  private var titleView: some View {
    HStack(alignment: .top) {
      if showsIndicator {
        VStack {
          Text(currentValue.formatted(FloatingPointFormatStyle.Currency(code: currency.code, locale: Locale.current).precision(.fractionLength(1))))
            .font(.title).fontWeight(.bold)
            .foregroundColor(.primary)
            .transition(.scale)
          Spacer()
        }
      } else {
        VStack(alignment: .leading, spacing: 4) {
          Text("Trend").font(.headline)
          Text("Balances").font(.footnote)
            .foregroundColor(.secondary)
        }
      }
      Spacer()
      Image(systemName: "waveform.path.ecg")
    }
    .frame(height: 40)
  }

  struct LegendView: View {
    var histogram: Histogram<Dimension>

    var body: some View {
      HStack(alignment: .bottom) {
        ForEach(histogram.units.map(\.symbol), id: \.self) { symbol in
          Text(symbol)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
        }
      }
    }
  }
}

extension TrendView {
  @discardableResult
  func handleTouch(to point: CGPoint, in frame: CGSize) -> CGPoint {
    let points = histogram.points()

    let stepWidth: CGFloat = frame.width / CGFloat(points.count - 1)
    let stepHeight: CGFloat = (frame.height - 60) / CGFloat(points.max()! - points.min()!)

    let index = Int(round((point.x) / stepWidth))

    if index >= 0 && index < points.count {
        currentValue = points[index]
        return CGPoint(x: CGFloat(index) * stepWidth, y: CGFloat(points[index]) * stepHeight)
    }
    return .zero
  }
}


#if DEBUG

struct TrendView_Preview: PreviewProvider {
  static var previews: some View {
    TrendView(histogram: Histogram(values: [("Feb", 23), ("Mar", 45), ("Apr", 30), ("May", 13), ("Jun", 23), ("Jul", 66)]), currency: Currency.usd)
      .frame(height: 300)
      .padding()
      .background(Color.secondary)
  }
}

#endif
