//
//  TransactionList.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/5.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct TransactionList: View {
  @EnvironmentObject var store: AppStore
  @State private var transaction: Transaction?

  var body: some View {
    List {
      ForEach(Alne.Transactions.samples()) { transaction in
        TransactionRow(transaction: transaction)
          .onTapGesture {
            self.transaction = transaction
        }
      }
    }
    .navigationBarTitle("Transactions")
    .sheet(item: $transaction) { transaction in
      ComposerView(mode: .edit).environmentObject(self.store)
    }
  }
}

#if DEBUG
struct TransactionList_Previews: PreviewProvider {
  static var previews: some View {
    TransactionList()
  }
}
#endif
