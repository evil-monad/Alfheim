//
//  PieChart.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct PieChart: View {
  @ObservedObject var data: UnitData
  var title: String
  var legend: String?

  init(data: [Double], title: String, legend: String? = nil) {
    self.data = UnitData(points: data)
    self.title = title
    self.legend = legend
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.white)
          .shadow(radius: 8)
        VStack(alignment: .leading) {
          HStack {
            VStack(alignment: .leading, spacing: 8) {
              Text(self.title).font(.system(size: 24, weight: .semibold)).foregroundColor(.black)
              if (self.legend != nil) {
                Text(self.legend!).font(.callout).foregroundColor(.gray).padding(.leading, 2)
              }
            }
            Spacer()
            Image(systemName: "chart.pie.fill")
          }
          .frame(width: nil, height: 80, alignment: .center)
          .padding()

          Spacer()

          GeometryReader { geometry in
            Pie(data: self.data)
          }
          .clipShape(RoundedRectangle(cornerRadius: 20))
          .offset(x: 0, y: 0)
          .padding(.bottom, 30)
        }
      }
    }
  }
}

#if DEBUG
struct PieChart_Previews : PreviewProvider {
  static var previews: some View {
    PieChart(data: [8,23,54,32,12,7,43], title: "Pie", legend: "accounts")
      .environment(\.colorScheme, .light)
  }
}
#endif
