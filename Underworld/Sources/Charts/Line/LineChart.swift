//
//  LineChart.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/20.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

public struct LineChart: View {
  @ObservedObject var histogram: Histogram<Dimension>
  var title: String
  var legend: String?

  public typealias Value = (rate: Double, specifier: String)
  private var value: Value
  private var symbol: String?

  @State private var touchLocation: CGPoint = .zero
  @State private var showsIndicator: Bool = false
  @State private var currentValue: Double = 0

  public init(data: [Int], title: String, legend: String? = nil, value: Value, symbol: String? = nil) {
    self.init(data: data.map { Double($0) },
              title: title,
              legend: legend,
              value: value,
              symbol: symbol)
  }

  public init(data: [Double], title: String, legend: String? = nil, value: Value, symbol: String? = nil) {
    self.init(histogram: Histogram(points: data),
              title: title,
              legend: legend,
              value: value,
              symbol: symbol)
  }

  public init(histogram: Histogram<Dimension>,
       title: String,
       legend: String? = nil,
       value: Value,
       symbol: String? = nil) {
    self.histogram = histogram
    self.title = title
    self.legend = legend
    self.value = value
    self.symbol = symbol
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(.systemBackground))
          .shadow(color: Color.shadow, radius: 8)
        VStack(alignment: .leading) {
          if !showsIndicator {
            VStack(alignment: .leading, spacing: 8) {
              Text(title).font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary)
              if legend != nil {
                Text(legend!).font(.callout)
                  .foregroundColor(.secondary)
              }
              HStack {
                /*
                if self.value.rate >= 0 {
                  Image(systemName: "arrow.up")
                } else {
                  Image(systemName: "arrow.down")
                }*/
                Text("\(symbol ?? "")\(value.rate, specifier: value.specifier)")
                  .foregroundColor(.primary)
              }
            }
            .transition(.opacity.animation(.easeIn(duration: 0.1)))
            .padding(.leading, 20)
            .frame(width: nil, height: 80, alignment: .center)
            .padding(.bottom, 24)
          } else {
            HStack {
              Spacer()
              Text("\(currentValue, specifier: value.specifier)")
                .font(.system(size: 41, weight: .bold))
                .foregroundColor(.primary)
              Spacer()
            }
            .transition(.scale)
            .frame(width: nil, height: 80, alignment: .center)
            .padding(.bottom, 24)
          }
          Spacer()
          GeometryReader { geometry in
            Line(histogram: histogram, frame: geometry.frame(in: .local), touchLocation: touchLocation, showsIndicator: showsIndicator)
          }
          .offset(x: 0, y: 0)
          .gesture(DragGesture()
            .onChanged { value in
              touchLocation = value.location
              showsIndicator = true
              handleTouch(to: value.location, in: geometry.frame(in: .local).size)
            }
            .onEnded { value in
              showsIndicator = false
            }
          )
        }
        .padding(.vertical, 20)
      }
    }
  }
}

extension LineChart {
  @discardableResult
  func handleTouch(to point: CGPoint, in frame: CGSize) -> CGPoint {
    let points = histogram.points()

    let stepWidth: CGFloat = frame.width / CGFloat(points.count - 1)
    let stepHeight: CGFloat = (frame.height - 60) / CGFloat(points.max()! - points.min()!)

    let index = Int(round((point.x) / stepWidth))

    if (index >= 0 && index < points.count){
        currentValue = points[index]
        return CGPoint(x: CGFloat(index) * stepWidth, y: CGFloat(points[index]) * stepHeight)
    }
    return .zero
  }
}

#if DEBUG
struct LineChart_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LineChart(data: [11, 3, 2, 5, 29, 9], title: "Line chart", legend: "Basic", value: (14, "%.1f"))
    }.environment(\.colorScheme, .dark)
  }
}
#endif
