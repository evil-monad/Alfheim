//
//  TransactionsView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/14.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct TransactionsView: View {
  var body: some View {
    NavigationView {
      List {
        TransactionList()
      }
      .navigationBarTitle("Transactions")
      .navigationBarItems(leading: Text("Done"))
    }
  }
}

struct TransactionsView_Previews: PreviewProvider {
  static var previews: some View {
    TransactionsView()
  }
}
