//
//  TransactionsView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/14.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct TransactionsView: View {
//  @EnvironmentObject var store: AppStore
//  @State private var transaction: Alne.Transaction?
//
//  private var state: AppState.TransactionList {
//    store.state.transactions
//  }
//
//  var body: some View {
//    Group {
//      if !state.isLoading && state.transactions.isEmpty {
//        Spacer()
//          .onAppear() {
//            self.store.dispatch(.transactions(.loadAll))
//        }
//      } else {
//        TransactionList()
//          .navigationBarTitle("Transactions")
//      }
//    }
//    .navigationBarItems(trailing:
//      Button(action: {
//      }) {
//        Image(systemName: "line.horizontal.3.decrease.circle").padding(.vertical).padding(.leading)
//      }
//    )
//  }
//}
//
//#if DEBUG
//struct TransactionsView_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationView {
//      TransactionsView()
//    }
//  }
//}
//#endif
