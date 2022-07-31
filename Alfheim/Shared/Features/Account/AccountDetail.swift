//
//  AccountDetail.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct AccountDetail: View {
//  @EnvironmentObject var store: AppStore
//
//  var onDismiss: () -> Void
//
//  private var state: AppState {
//    store.state
//  }
//
//  var body: some View {
//    NavigationView {
//      AccountDetailList(account: $store.state.accountDetail.account)
//        .navigationBarTitle("Account")
//        .navigationBarItems(
//          leading: Button(action: onDismiss) {
//            Text("Cancel")
//          },
//          trailing: Button(action: {
//            self.store.dispatch(.account(.update(self.store.state.accountDetail.account)))
//          }) {
//            Text("Save").bold()
//          }
//      )
//    }
//    .navigationViewStyle(StackNavigationViewStyle())
//  }
//}
//
//#if DEBUG
//struct AccountDetail_Previews: PreviewProvider {
//  static var previews: some View {
//    AccountDetail(onDismiss: {})
//  }
//}
//#endif
