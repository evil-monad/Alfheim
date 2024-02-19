//
//  TransactionList.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/5.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Alne

struct TransactionList: View {
  @Bindable var store: StoreOf<Transaction>

  var body: some View {
    List {
      ForEach(store.filteredTransactions) { section in
        Section {
          EmptyView()
          ForEach(section.viewStates) { state in
            row(state)
          }
          .listRowInsets(EdgeInsets.default)
        } header: {
          Text("\(section.date.formatted(.dateTime.year().day().month()))")
            .fontWeight(.medium)
            .font(.subheadline).foregroundColor(.primary)
            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
        }
        .textCase(nil)
      }
      .listStyle(.insetGrouped)
    }
    .navigationTitle(store.title)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Picker(
            selection: $store.filter.sending(\.filtered),
            label: Text("Period")
          ) {
            ForEach(Transaction.State.Filter.allCases, id: \.self) { filter in
              Text(filter.name).tag(filter)
            }
          }
        } label: {
          Label("Filter", systemImage: store.filter != .none ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
        }
        .disabled(!store.isFilterEnabled)
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .id(store.id)
  }

  @ViewBuilder
  private func row(_ state: Transactions.ViewState) -> some View {
    TransactionRow(transaction: state)
      .disclosure(alignment: .center)
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button(role: .destructive) {
          store.send(.delete(state.transaction))
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        Button {
          store.send(.toggleFlag(state.transaction))
        } label: {
          Label(state.flagged ? "Unflag" : "Flag", systemImage: state.flagged ? "flag.slash" : "flag.fill")
        }
        .tint(state.flagged ? .indigo : .blue)
      }
  }
}
