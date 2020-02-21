//
//  AccountDetail.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct AccountDetail: View {
  var account: Account

  var onDismiss: () -> Void
  
  var body: some View {
    NavigationView {
      AccountDetailList(account: account)
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Account")
        .navigationBarItems(
          leading: Button(action: onDismiss) {
            Text("Cancel")
          },
          trailing: Button(action: {
            // self.onDismiss()
          }) {
            Text("Save")
        })
    }
  }
}

#if DEBUG
struct AccountDetail_Previews: PreviewProvider {
  static var previews: some View {
    AccountDetail(account: Accounts.expenses, onDismiss: {})
  }
}
#endif
