//
//  AccountDetailList.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import Domain

struct AccountDetailList: View {
  @Binding var account: Domain.Account

  var body: some View {
    List {
      Section(header: Spacer()) {
        Text(account.name)
        Text(account.introduction)
      }

      Section {
        ForEach(Tagit.allCases) { tag in
          HStack {
            Circle().fill(Color(tagit: tag)).frame(width: 20, height: 20)
            Text(tag.name)
            Spacer()
            if tag.rawValue == self.account.tag {
              Image(systemName: "checkmark")
                .font(.body.bold())
                .foregroundColor(.blue)
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            self.account.tag = tag.rawValue
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
}

#if DEBUG
struct AccountDetailList_Previews: PreviewProvider {
  @State static var account = Domain.Account.mock()
  static var previews: some View {
    AccountDetailList(account: $account)
  }
}
#endif
