//
//  Pie.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct Pie: View {
  @ObservedObject var histogram: Histogram<PieUnit>

  private var slices: [Slice.Data] {
    var slices: [Slice.Data] = []
    var degrees: Double = 0
    let sum = histogram.points().reduce(0, +)

    for unit in histogram.units {
      let normalized: Double = Double(unit.value)/Double(sum)
      let startDegrees = degrees
      let endDegress = degrees + (normalized * 360)
      let data = Slice.Data(startDegrees: startDegrees,
                            endDegrees: endDegress,
                            unit: unit,
                            color: unit.color,
                            normalizedValue: normalized)
      slices.append(data)
      degrees = endDegress
    }
    return slices
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(0..<slices.count) { index in
          slice(at: index)
        }
      }
    }
  }

  private func slice(at index: Int) -> Slice {
    let data = slices[index]
    return Slice(startDegrees: data.startDegrees,
                 endDegrees: data.endDegrees,
                 index: index,
                 color: data.color)
  }
}

#if DEBUG
struct Pie_Previews : PreviewProvider {
  static var previews: some View {
    GeometryReader { geometry in
      Pie(histogram:  Histogram(values: [("Mon", 8, "a", Color.red), ("Tue", 18, "b", Color.green), ("Wed", 28, "c", Color.blue), ("Thu", 12, "d", Color.brown), ("Fri", 16, "e", Color.pink), ("Sat", 22, "f", Color.cyan), ("Sun", 20, "g", Color.orange)]))
    }.frame(width: 200, height: 200)
  }
}
#endif
