//
//  StatisticList.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct StatisticList: View {
//  @EnvironmentObject var store: AppStore
//
//  private var state: AppState.Statistics {
//    store.state.statistics
//  }
//
//  private var transactions: [Alfheim.Transaction] {
//    state.transactions
//  }
//
//  private var lineData: [Double] {
//    transactions.reversed().map { $0.amount }
//  }
//
//  private var trend: Double {
//    guard !lineData.isEmpty else {
//      return 0
//    }
//    return lineData.reduce(0, +)
//    //return (lineData.last! - lineData.first!) / lineData.first! * 100.0
//  }
//
//  private var pieData: [(String, Double, String)] {
//    state.categorized
//      .map { category, viewModels in
//        (category, viewModels.reduce(0.0, { $0 + $1.amount }), viewModels.first!.catemoji.category.text)
//      }
//  }
//
//  private var barData: [(String, Double)] {
//    state.labeledAmount(with: state.preferPeriod)
//  }
//
//  private var barTitle: String {
//    state.title(with: state.preferPeriod)
//  }
//
//  private var barLegend: String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMM dd"
//    let range = state.closedTimeRange
//    return "\(formatter.string(from: range.start)) - \(formatter.string(from: range.end))"
//  }
//
//  private var symbol: String {
//    state.account.currency.symbol
//  }
//
//  private static let height: CGFloat = 280
//
//  var body: some View {
//    GeometryReader { geometry in
//      ScrollView(.vertical, showsIndicators: false) {
//        VStack(spacing: 24) {
//          BarChart(data: self.barData,
//                   title: self.barTitle,
//                   legend: self.barLegend)
//            .frame(height: StatisticList.height)
//
//          LineChart(data: self.lineData,
//                    title: self.state.account.name,
//                    legend: self.state.period.display,
//                    value: (self.trend, "%.1f"),
//                    symbol: self.symbol)
//            .frame(height: StatisticList.height)
//
//          PieChart(data: self.pieData,
//                   title: "Categories",
//                   legend: "\(self.pieData.count) total",
//            symbol: self.symbol)
//        }
//        .padding(20)
//      }
//    }
//  }
//}
//
//#if DEBUG
//struct StatisticList_Previews: PreviewProvider {
//  static var previews: some View {
//    StatisticList().environmentObject(AppStore(moc: viewContext))
//  }
//}
//#endif
