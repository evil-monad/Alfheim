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

//struct TransactionList: View {
//  @EnvironmentObject var store: AppStore
//
//  private var state: AppState.TransactionList {
//    store.state.transactions
//  }
//
//  private var binding: Binding<AppState.TransactionList> {
//    $store.state.transactions
//  }
//
//  private var tag: Tagit {
//    store.state.shared.account.tag
//  }
//
//  private var viewModel: TransactionListViewModel {
//    state.listViewModel(filterDate: filterDate, tag: tag)
//  }
//
//  private var displayTransactions: [Alfheim.Transaction] {
//    viewModel.viewModels.map { $0.transaction }
//  }
//
//  @State private var filterDate = Date()
//  @State private var selectedDate = Date()
//  @State private var showDatePicker = false
//
//  var body: some View {
//    List {
//      Section(header:
//        HStack {
//          HStack(alignment: .lastTextBaseline) {
//            Text(viewModel.selectedMonth)
//              .font(.system(size: 34, weight: .semibold))
//              .foregroundColor(.primary)
//            Text(viewModel.selectedYear)
//              .font(.system(size: 28, weight: .medium))
//              .foregroundColor(.secondary)
//
//            Image(systemName: "chevron.down")
//              .font(.system(size: 16, weight: .medium))
//              .foregroundColor(.secondary)
//              .padding(.bottom, 2)
//          }
//          .onTapGesture {
//            self.showDatePicker = true
//          }
//          Spacer()
//          Button(action: {
//            store.dispatch(.transactions(.showStatistics(displayTransactions, interval: filterDate.interval(of: .month)!)))
//          }) {
//            Text(self.viewModel.displayAmountText)
//              .font(.system(size: 18))
//              .foregroundColor(.secondary)
//            Image(systemName: "chevron.right")
//              .font(.system(size: 18))
//              .foregroundColor(.secondary)
//          }
//          .modal(
//            isPresented: self.binding.isStatisticsPresented,
//            onDismiss: {
//              store.dispatch(.transactions(.dimissStatistics))
//          }) {
//            StatisticsView().environmentObject(self.store)
//          }
//        }
//        .foregroundColor(.primary)
//      ) {
//        ForEach(self.viewModel.viewModels) { viewModel in
//          TransactionRow(model: viewModel)
//            .onTapGesture {
//              self.store.dispatch(.transactions(.editTransaction(viewModel.transaction)))
//          }
//        }
//        .onDelete { indexSet in
//          self.store.dispatch(.transactions(.delete(in: displayTransactions, at: indexSet)))
//        }
//      }
//    }
//    .listStyle(GroupedListStyle())
//    .navigationBarTitle("Transactions", displayMode: .inline)
//    .sheet(
//      isPresented: binding.editingTransaction,
//      onDismiss: {
//        self.store.dispatch(.transactions(.editTransactionDone))
//    }) {
//      ComposerView(mode: .edit).environmentObject(self.store)
//    }
//    .overlaySheet(
//      isPresented: self.$showDatePicker,
//      onDismiss: {
//        self.showDatePicker = false
//    }) {
//      VStack {
//        HStack {
//          Text(self.pickedDateText)
//            .fontWeight(.medium)
//          Spacer()
//          Button(action: {
//            self.showDatePicker = false
//            self.filterDate = self.selectedDate
//          }) {
//            Text("OK").bold()
//          }
//        }
//        .padding([.top, .leading, .trailing])
//        DatePicker("",
//                   selection: self.$selectedDate,
//                   in: ...Date(),
//                   displayedComponents: .date)
//          .datePickerStyle(WheelDatePickerStyle())
//          .background(Color(.systemBackground))
//      }
//      .background(Color(.secondarySystemBackground))
//    }
//  }
//
//  private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMMM, yyyy"
//    return formatter
//  }()
//
//  private var pickedDateText: String {
//    return dateFormatter.string(from: selectedDate)
//  }
//}
//
//#if DEBUG
//struct TransactionList_Previews: PreviewProvider {
//  static var previews: some View {
//    TransactionList()
//  }
//}
//#endif
