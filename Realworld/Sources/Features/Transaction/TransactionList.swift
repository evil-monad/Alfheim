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
  let store: Store<Transaction.State, Transaction.Action>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      List {
        ForEach(vs.filteredTransactions) { section in
          Section {
            ForEach(section.viewStates) { viewState in
              TransactionRow(transaction: viewState)
                .disclosure(alignment: .center)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                  Button(role: .destructive) {
                    vs.send(.delete(viewState.transaction))
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                  Button {
                    vs.send(.toggleFlag(viewState.transaction))
                  } label: {
                    Label(viewState.flagged ? "Unflag" : "Flag", systemImage: viewState.flagged ? "flag.slash" : "flag.fill")
                  }
                  .tint(viewState.flagged ? .indigo : .blue)
                }
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
      }
      .listStyle(.insetGrouped)
      .navigationTitle(vs.title)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Menu {
            Picker(
              selection: vs.binding(get: \.filter, send: Transaction.Action.filter),
              label: Text("Period")
            ) {
              ForEach(Transaction.State.Filter.allCases, id: \.self) { filter in
                Text(filter.name).tag(filter)
              }
            }
          } label: {
            Label("Filter", systemImage: vs.filter != .none ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
          }
          .disabled(!vs.isFilterEnabled)
        }
      }
      .onAppear {
        vs.send(.onAppear)
      }
      .id(vs.id)
    }
  }

  /*
  @ViewBuilder
  private func section(
    _ section: Transaction.State.SectionedTransaction) -> some View {
      WithViewStore(
        store,
        observe: { $0 }
      ) { vs in
        Section {
          ForEach(section.viewStates) { viewState in
            self.row(viewState.transaction)
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
  }

  @ViewBuilder
  private func row(
    _ transaction: Domain.Transaction) -> some View {
      WithViewStore(
        store,
        observe: { _ in
          Transactions.ViewState(transaction: transaction, tag: Tagit.alfheim, deposit: false, ommitedDate: true)
        }
      ) { vs in
        TransactionRow(transaction: vs.state)
          .disclosure(alignment: .center)
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              vs.send(.delete(vs.transaction))
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
          .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
              vs.send(.toggleFlag(flag: !vs.flagged, id: vs.id))
            } label: {
              Label(vs.flagged ? "Unflag" : "Flag", systemImage: vs.flagged ? "flag.slash" : "flag.fill")
            }
            .tint(vs.flagged ? .indigo : .blue)
          }
      }
  }
   */
}
