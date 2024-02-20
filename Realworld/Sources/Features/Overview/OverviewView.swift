//
//  OverviewView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Charts

struct OverviewView: View {
  @Bindable var store: Store<Overview.State, Overview.Action>

  init(store: Store<Overview.State, Overview.Action>) {
    self.store = store
  }

  var body: some View {
    List {
      Section {
        AccountCard(store: store)
          .frame(height: 200)
      }
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)

      if store.showRecentTransactionsSection {
        TransactionSection(store: store)
      }

      if store.showStatisticsSection {
        StatisticsSection(store: store)
      }
    }
    .navigationTitle(store.account.name)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          store.send(.toggleNewTransaction(presenting: true))
        } label: {
          Image(systemName: "plus.circle")
        }
        .disabled(store.account.root)
      }
    }
    .sheet(isPresented: $store.isEditorPresented.sending(\.toggleNewTransaction)) {
      ComposerView(
        store: store.scope(
          state: \.editor,
          action: \.editor
        ),
        mode: .new
      )
    }
    .onAppear {
      store.send(.onAppear)
    }
    .id(store.account.id)
  }
}

private struct TransactionSection: View {
  let store: Store<Overview.State, Overview.Action>

  var body: some View {
    Section {
      ForEach(store.recentTransactions) { transaction in
        TransactionRow(transaction: Transactions.ViewState(transaction: transaction, tag: store.account.tagit, deposit: store.account.summary.isAncestor(of: transaction.target)))
      }
      .listRowInsets(EdgeInsets.default)
    } header: {
      NavigationLink(state: App.Path.State.transation(store.transactions)) {
        Header("Transactions")
      }
      .listRowInsets(.headerInsets)
    }
  }
}

private struct StatisticsSection: View {
  let store: Store<Overview.State, Overview.Action>

  var body: some View {
    Section {
      if store.showTrendStatistics {
        TrendView(
          units: store.trendUnit.map { Dimension(symbol: $0.name, value: $0.value) },
          currency: store.account.currency
        )
        .frame(height: 240)
        .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 16, trailing: 16))
      } else {
        CompositionView(
          units: store.compositonUnit.map { PieUnit(label: $0.name, value: $0.value, symbol: $0.symbol, color: $0.tagit.color) }
        )
        .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 16, trailing: 16))
      }
    } header: {
      Header("Statistics")
        .listRowInsets(.headerInsets)
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
      text.fontWeight(.medium).font(.subheadline)
      Spacer()
      Image(systemName: "chevron.forward")
    }
    .foregroundColor(.primary)
    .textCase(nil)
  }
}

fileprivate extension EdgeInsets {
  static let headerInsets = EdgeInsets(top: 6, leading: 4, bottom: 0, trailing: 4)
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

#endif
