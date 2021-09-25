//
//  AccountDetailList.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct AccountDetailList: View {
  @Binding var account: Alne.Account

  var body: some View {
    List {
      Section(header: Spacer()) {
        Text(account.name)
        Text(account.description)
      }

      Section {
        ForEach(Tagit.allCases) { tag in
          HStack {
            Circle().fill(Color(tagit: tag)).frame(width: 20, height: 20)
            Text(tag.name)
            Spacer()
            if tag == self.account.tag {
              Image(systemName: "checkmark")
                .font(.body.bold())
                .foregroundColor(.blue)
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            self.account.tag = tag
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
}

#if DEBUG
struct AccountDetailList_Previews: PreviewProvider {
  @State static var account = Alne.Accounts.expenses
  static var previews: some View {
    AccountDetailList(account: $account)
  }
}
#endif
