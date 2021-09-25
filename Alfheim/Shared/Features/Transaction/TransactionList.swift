//
//  TransactionList.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/5.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct TransactionList: View {
  let store: Store<AppState.Transaction, AppAction.Transaction>

  var body: some View {
    WithViewStore(store) { vs in
      List {
        ForEach(vs.sectionedTransactions) { section in
          Section {
            ForEach(section.viewStates) { transaction in
              TransactionRow(transaction: transaction)
                .disclosure(alignment: .center)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                  Button(role: .destructive) {
                    vs.send(.delete(id: transaction.id))
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                  Button {
                    vs.send(.toggleFlag(flag: !transaction.flagged, id: transaction.id))
                  } label: {
                    Label(transaction.flagged ? "Unflag" : "Flag", systemImage: transaction.flagged ? "flag.slash" : "flag.fill")
                  }
                  .tint(transaction.flagged ? .indigo : .blue)
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
    }
  }
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
