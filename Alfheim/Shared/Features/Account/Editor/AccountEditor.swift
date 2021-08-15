//
//  AccountEditor.swift
//  AccountEditor
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AccountEditor: View {
  let store: Store<AppState.AccountEditor, AppAction.AccountEditor>

  enum Mode {
    case new
    case edit
  }
  
  var body: some View {
    WithViewStore(store) { vs in
      List {
        Section(header: Spacer()) {
          TextField("Name", text: vs.binding(get: \.name,
                                             send: { .changed(.name($0)) }))
          TextField("Description", text: vs.binding(get: \.introduction,
                                                    send: { .changed(.introduction($0)) }))
        }

        Section {
          AccountPicker(
            vs.state.groupedRootAccounts,
            selection: vs.binding(get: { $0.parent }, send: { .changed(.parent($0)) })) {
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
}

//
//struct AccountEditor_Previews: PreviewProvider {
//  static var previews: some View {
//    AccountEditor()
//  }
//}
