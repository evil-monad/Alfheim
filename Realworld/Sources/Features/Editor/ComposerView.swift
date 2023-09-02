//
//  ComposerView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ComposerView: View {
  @Environment(\.dismiss) var dismiss
  let store: Store<Editor.State, Editor.Action>

  let mode: EditorView.Mode

  var body: some View {
    NavigationStack {
      WithViewStore(store, observe: { $0 }) { vs in
        EditorView(store: store)
          .navigationTitle(vs.isNew ? " New Transaction" : "Edit Transaction")
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button {
                let action = Editor.Action.save(vs.transaction, mode: vs.isNew ? .new : .update)
                vs.send(action)
                dismiss()
              } label: {
                Text("Save").bold()
              }
              .disabled(!vs.isValid)
            }
            ToolbarItem(placement: .cancellationAction) {
              Button {
                dismiss()
              } label: {
                Text("Cancel")
              }
            }
          }
      }
    }
    .navigationViewStyle(.stack)
    .task {
      store.send(.loadAccounts)
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
        store.send(.focused(.amount))
      }
    }
  }
}

#if DEBUG
//struct ComposerView_Previews: PreviewProvider {
//  static var previews: some View {
//    ComposerView(mode: .new)
//  }
//}
#endif
