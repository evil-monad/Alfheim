//
//  EditAccountForm.swift
//  Alfheim
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Alne
import Domain
import Components

struct EditAccountForm: View {
  @Bindable var store: StoreOf<EditAccount>
  @FocusState private var focus: EditAccount.State.FocusField?

  var body: some View {
    List {
      Section {
        TextField(
          "Name",
          text: $store.name
        )
        .focused($focus, equals: .name)

        TextField(
          "Description",
          text: $store.introduction
        )
        .focused($focus, equals: .introduction)
      }

      Section {
        AccountPicker(
          accounts: store.groupedRootAccounts,
          selection: $store.parent
        ) {
          Text("Group")
        }

        EmojiPicker(
          selection: $store.emoji
        ) {
          Text("Emoji")
        }
      }

      Section {
        ForEach(Tagit.allCases) { tag in
          HStack {
            Circle().fill(Color(tagit: tag)).frame(width: 20, height: 20)
            Text(tag.name)
            Spacer()
            if tag.rawValue == store.tag {
              Image(systemName: "checkmark")
                .font(Font.body.bold())
                .foregroundColor(.blue)
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            store.send(.binding(.set(\.tag, tag.rawValue)))
            // store.send(.changed(.tag(tag.rawValue)))
          }
        }
      }
    }
    .listStyle(.insetGrouped)
  }

  private var accountPicker: some View {
    NavigationLink {
      HierarchyAccountPicker(
        store.groupedRootAccounts
      ) { account in
        Button {
          store.send(.binding(.set(\.parent, account.summary)))
          // store.send(.changed(.parent(account.summary)))
          // popback
        } label: {
          HStack {
            Group {
              if store.parent == account.summary {
                Image(systemName: "checkmark").foregroundColor(.blue)
              } else {
                Text("\(account.emoji ?? "")")
              }
            }
            .frame(width: 22)
            Text(account.name)
          }
        }
      }
    } label: {
      HStack {
        Text("Group")
        Spacer()
        Text(store.parent?.name ?? "")
      }
    }
  }
}

//
//struct EditAccountView_Previews: PreviewProvider {
//  static var previews: some View {
//    AccountEditor()
//  }
//}
