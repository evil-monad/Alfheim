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
          TransactionRow(transaction: TransactionViewState(transaction: transaction, tag: .alfheim, deposit: transaction.target == vs.account))
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
      VStack(alignment: .leading, spacing: 8) {
        ForEach(0..<histogram.units.count) { index in
          HStack(spacing: 0) {
            HStack {
              Text(unit(at: index).label)
                .font(.system(size: 20, weight: .medium))
              Spacer()
            }
            .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
              HStack {
                Text(unit(at: index).symbol).font(.system(size: 12))
                Text("\(percent(at: index) * 100, specifier: "%.1f")%")
                  .font(.system(size: 10))
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
                Text("\("")\(unit(at: index).value, specifier: "%.1f")")
                  .font(.system(size: 14))
              }
              .frame(width: 40)
            }
          }
          .frame(height: 30)
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
      let percent = self.percent(at: index)
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

//struct OverviewView: View {
//  @Environment(\.horizontalSizeClass) var horizontalSizeClass
//  /// App Store
//  @EnvironmentObject var store: AppStore
//  /// Ovewview state
//  private var state: AppState.Overview {
//    store.state.overview
//  }
//  /// Shared state
////  private var shared: AppState.Shared {
////    store.state.shared
////  }
//  /// Overview binding
//  private var binding: Binding<AppState.Overview> {
//    $store.state.overview
//  }
//
//  var account: Alfheim.Account
//
//  var body: some View {
////    NavigationView {
//      GeometryReader { geometry in
//        ScrollView(.vertical, showsIndicators: false) {
//          VStack {
//            self.accountCard(height: geometry.size.width*9/16)
//            Spacer().frame(height: 36)
//            //self.transactions()
//          }
//          .padding(18)
//        }
//      }
//      .navigationBarTitle(account.name)
//      .navigationBarItems(
//        leading: Button(action: {
//          self.store.dispatch(.overview(.toggleSettings(presenting: true)))
//        }) {
//          //Text("Settings").bold()
//          Image(systemName: "gear").padding(.vertical).padding(.trailing)
//        },
//        trailing: Button(action: {
//          self.store.dispatch(.overview(.toggleNewTransaction(presenting: true)))
//        }) {
//          //Text("New Transation").bold()
//          //Image(systemName: "plus")
//          Image(systemName: "plus.circle").padding(.vertical).font(Font.system(size: 18)).padding(.leading)
//        }
//        .sheet(
//          isPresented: binding.isEditorPresented,
//          onDismiss: {
//            self.store.dispatch(.overview(.toggleNewTransaction(presenting: false)))
//        }) {
//          ComposerView(mode: .new)
//            .environmentObject(self.store)
//        }
//      )
//      .modal(isPresented: binding.isOnboardingPresented) {
//        OnboardingView()
//          .environmentObject(self.store)
//      }
////    }
//  }
//
//  private func accountCard(height: CGFloat) -> some View {
//    AccountCard()
//      .frame(height: height)
//      .background(
//        Spacer()
////          .sheet(
////            isPresented: self.binding.isStatisticsPresented,
////            onDismiss: {
////              self.store.dispatch(.overview(.toggleStatistics(presenting: false)))
////          }) {
////            StatisticsView().environmentObject(self.store)
////        }
//      )
//      .onTapGesture {
//        self.store.dispatch(.overview(.toggleStatistics(presenting: true)))
//    }
//  }
//
////  private func transactions() -> some View {
////    Section(header: NavigationLink(destination: TransactionList(), isActive: binding.isTransactionListActive) {
////      HStack {
////        Text("Transactions").font(.system(size: 24, weight: .bold))
////        Spacer()
////        Image(systemName: "chevron.right")
////      }
////      .foregroundColor(.primary)
////    }) {
////      ForEach(self.shared.displayTransactions) { viewModel in
////        TransactionRow(model: viewModel)
////          .onTapGesture {
////            self.store.dispatch(.overview(.editTransaction(viewModel.transaction)))
////        }
////      }
////    }
////    .sheet(
////      isPresented: self.binding.editingTransaction,
////      onDismiss: {
////        self.store.dispatch(.overview(.editTransactionDone))
////    }) {
////      ComposerView(mode: .edit).environmentObject(self.store)
////    }
////    /* don't use this
////    .sheet(item: self.binding.selectedTransaction) { transaction in
////      ComposerView(mode: .edit) {
////        self.store.dispatch(.overview(.editTransactionDone))
////      }
////      .environmentObject(self.store)
////    }*/
////  }
//}
//
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
#endif
