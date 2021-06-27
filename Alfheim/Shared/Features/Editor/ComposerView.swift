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
  let store: Store<AppState.Editor, AppAction.Editor>

  let mode: EditorView.Mode

  var body: some View {
    NavigationView {
      WithViewStore(store) { viewStore in
        EditorView(store: store)
          .navigationTitle(viewStore.isNew ? " New Transaction" : "Edit Transaction")
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button {
                let action = AppAction.Editor.save(viewStore.transaction, mode: viewStore.isNew ? .new : .update)
                viewStore.send(action)
                dismiss()
              } label: {
                Text("Save").bold()
              }
              .disabled(!viewStore.isValid)
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
  }
}

#if DEBUG
//struct ComposerView_Previews: PreviewProvider {
//  static var previews: some View {
//    ComposerView(mode: .new)
//  }
//}
#endif
