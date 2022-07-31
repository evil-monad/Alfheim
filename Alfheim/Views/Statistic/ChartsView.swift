//
//  ChartsView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/5/23.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct ChartsView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        BarChart(data: self.barData, title: "Week", legend: "Chart")
          .frame(height: 280)

        LineChart(data: self.lineData, title: "Month", legend: "Chart", value: (10.0, "%.1f"))
          .frame(height: 280)

        PieChart(data: self.values, title: "Categories", legend: "7 total", symbol: "$")

        ForEach(0..<20) { index in
          Text("Hello \(index)")
        }
      }
      .padding()
    }
  }

  var barData: [(String, Double)] {
    return self.values.map { s, v, l in
      (s, Double(v))
    }
  }

  var lineData: [Double] {
    self.values.map { Double($0.1) }
  }

  var values = [("Sat", 0, "Fruit"), ("Sun", 30, "Food"), ("Mon", 18, "People"), ("Tue", 28, "Animal"), ("Wed", 36, "Household"), ("Thu", 23, "Sports"), ("Fri", 16, "Sleep")]
}

#if DEBUG
struct ChartsView_Previews: PreviewProvider {
  static var previews: some View {
    ChartsView()
  }
}
#endif
