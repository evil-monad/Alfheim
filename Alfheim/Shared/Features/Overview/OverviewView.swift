//
//  OverviewView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct OverviewView: View {
  let store: Store<AppState.Overview, AppAction.Overview>

  var body: some View {
    WithViewStore(store) { vs in
      List {
        Section {
          AccountCard(store: store)
            .frame(height: 200)
        } header: {
          Header(vs.period.display)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)

        if vs.showRecentTransactionsSection {
          TransactionSection(store: store)
        }

        if vs.showStatisticsSection {
          StatisticsSection(store: store)
        }
      }
      .navigationTitle(vs.account.name)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            vs.send(.toggleNewTransaction(presenting: true))
          } label: {
            Image(systemName: "plus.circle")
          }
          .disabled(vs.account.root)
        }
      }
      .sheet(isPresented: vs.binding(get: \.isEditorPresented, send: { .toggleNewTransaction(presenting: $0) })) {
        ComposerView(
          store: store.scope(
            state: \.editor,
            action: AppAction.Overview.editor),
          mode: .new
        )
      }
    }
  }
}

private struct TransactionSection: View {
  let store: Store<AppState.Overview, AppAction.Overview>

  var body: some View {
    WithViewStore(store) { vs in
      Section {
        ForEach(vs.recentTransactions) { transaction in
          TransactionRow(transaction: TransactionViewState(transaction: transaction, tag: .alfheim, deposit: vs.account.isAncestor(of: transaction.target)))
        }
        .listRowInsets(EdgeInsets.default)
      } header: {
        Header("Transactions")
          .listRowInsets(EdgeInsets())
      }
    }
  }
}

private struct StatisticsSection: View {
  let store: Store<AppState.Overview, AppAction.Overview>

  var body: some View {
    WithViewStore(store) { vs in
      Section {
        VStack(spacing: 24) {
          titleView

          HStack(spacing: 20) {
            Pie(histogram: Histogram(values: vs.statistics))
              .aspectRatio(1.0, contentMode: .fit)

            LegendView(histogram: Histogram(values: vs.statistics))
          }
          .padding(.horizontal, 4)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 16, trailing: 16))
      } header: {
        Header("Statistics")
          .listRowInsets(EdgeInsets())
      }
    }
  }

  private var titleView: some View {
    HStack {
      Text("Composition").font(.headline)
      Spacer()
      Image(systemName: "chart.pie.fill")
    }
  }

  struct LegendView: View {
    @ObservedObject var histogram: Histogram<LabeledUnit>
    let showsValue: Bool = false
    
    var body: some View {
      VStack(alignment: .leading, spacing: 6) {
        ForEach(0..<histogram.units.count) { index in
          HStack(spacing: 0) {
            HStack {
              Text(unit(at: index).label)
                .font(.title3)
              Spacer()
            }
            .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
              HStack {
                Text(unit(at: index).symbol).font(.caption)
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

    private func unit(at index: Int) -> LabeledUnit {
      histogram.units[index]
    }

    private func progressView(at index: Int, size: CGSize) -> some View {
      let percent = percent(at: index)
      var width = CGFloat(percent) * size.width
      if percent > 0 {
        width = max(width, size.height - 4)
      }
      return Capsule().fill(Color.with(symbol: unit(at: index).symbol, at: index))
        .frame(width: width)
    }
  }
}

private struct Header: View {
  let text: Text

  init(_ text: String) {
    self.text = Text(text)
  }

  var body: some View {
    HStack {
      text.font(.subheadline).foregroundColor(.primary)
      Spacer()
      Image(systemName: "chevron.right")
    }
  }
}


////#if DEBUG
////struct OverviewView_Previews: PreviewProvider {
////  static var previews: some View {
////    OverviewView().environment(\.colorScheme, .dark).environmentObject(AppStore(moc: viewContext))
////  }
////}
////#endif

#if DEBUG
struct Header_Previews: PreviewProvider {
  static var previews: some View {
    Header("List Header").environment(\.colorScheme, .dark)
  }
}

struct Legend_Preview: PreviewProvider {
  static var previews: some View {
    StatisticsSection.LegendView(histogram: Histogram(values: [("Sat", 0, "A"), ("Sun", 1, "A"), ("Mon", 18, "A"), ("Tue", 28, "A"), ("Wed", 36, "A"), ("Thu", 23, "A"), ("Fri", 100, "A")]))
  }
}
#endif
