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
  let store: Store<Overview.State, Overview.Action>

  init(store: Store<Overview.State, Overview.Action>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store, observe: { $0.contentState }) { vs in
      List {
        Section {
          AccountCard(store: store)
            .frame(height: 200)
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
      .navigationTitle(vs.accountName)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            vs.send(.toggleNewTransaction(presenting: true))
          } label: {
            Image(systemName: "plus.circle")
          }
          .disabled(vs.isRootAccount)
        }
      }
      .sheet(isPresented: vs.binding(get: \.isEditorPresented, send: { .toggleNewTransaction(presenting: $0) })) {
        ComposerView(
          store: store.scope(
            state: \.editor,
            action: Overview.Action.editor),
          mode: .new
        )
      }
      .onAppear {
        vs.send(.onAppear)
      }
    }
  }
}

private struct TransactionSection: View {
  let store: Store<Overview.State, Overview.Action>

  var body: some View {
    WithViewStore(store, observe: { $0.transactionState }) { vs in
      Section {
        ForEach(vs.recentTransactions) { transaction in
          TransactionRow(transaction: Transactions.ViewState(transaction: transaction, tag: vs.account.tagit, deposit: vs.account.summary.isAncestor(of: transaction.target)))
        }
        .listRowInsets(EdgeInsets.default)
      } header: {
        WithViewStore(store, observe: { $0 }) { vs in
          NavigationLink(state: App.Path.State.transation(vs.transactions)) {
            Header("Transactions")
          }
          .listRowInsets(.headerInsets)
        }
      }
    }
  }
}

private struct StatisticsSection: View {
  let store: Store<Overview.State, Overview.Action>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      Section {
        if vs.showTrendStatistics {
          TrendView(
            units: vs.trendUnit.map { Dimension(symbol: $0.name, value: $0.value) },
            currency: vs.account.currency
          )
          .frame(height: 240)
          .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 16, trailing: 16))
        } else {
          CompositionView(
            units: vs.compositonUnit.map { PieUnit(label: $0.name, value: $0.value, symbol: $0.symbol, color: $0.tagit.color) }
          )
          .listRowInsets(EdgeInsets(top: 14, leading: 12, bottom: 16, trailing: 16))
        }
      } header: {
        Header("Statistics")
          .listRowInsets(.headerInsets)
      }
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
  static let headerInsets = EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
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
