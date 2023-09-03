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
  let store: Store<EditAccount.State, EditAccount.Action>
  @FocusState private var focus: EditAccount.State.FocusField?
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      List {
        Section {
          TextField(
            "Name",
            text: vs.binding(get: \.name, send: { .changed(.name($0)) })
          )
          .focused($focus, equals: .name)

          TextField(
            "Description",
            text: vs.binding(get: \.introduction, send: { .changed(.introduction($0)) })
          )
          .focused($focus, equals: .introduction)
        }

        Section {
          AccountPicker(
            accounts: vs.groupedRootAccounts,
            selection: vs.binding(get: { $0.parent }, send: { .changed(.parent($0)) })
          ) {
            Text("Group")
          }

          EmojiPicker(
            selection: vs.binding(get: \.emoji,
                                  send: { .changed(.emoji($0)) })
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
              if tag.rawValue == vs.tag {
                Image(systemName: "checkmark")
                  .font(Font.body.bold())
                  .foregroundColor(.blue)
              }
            }
            .contentShape(Rectangle())
            .onTapGesture {
              vs.send(.changed(.tag(tag.rawValue)))
            }
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
    }
  }

  private var accountPicker: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      NavigationLink {
        HierarchyAccountPicker(
          vs.groupedRootAccounts
        ) { account in
          Button {
            vs.send(.changed(.parent(account.summary)))
            // popback
          } label: {
            HStack {
              Group {
                if vs.parent == account.summary {
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
          Text(vs.parent?.name ?? "")
        }
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
