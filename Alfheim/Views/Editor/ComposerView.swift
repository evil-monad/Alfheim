//
//  ComposerView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct ComposerView: View {
  // alternative dismiss
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var store: AppStore

  private var state: AppState.Editor {
    store.state.editor
  }

  let mode: EditorView.Mode

  var body: some View {
    NavigationView {
      EditorView()
        .navigationBarTitle(self.state.isNew ? " New Transaction" : "Edit Transaction")
        .navigationBarItems(
          leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("Cancel")
          },
          trailing: Button(action: {
            let action = AppAction.Editor.save(self.state.validator.transaction, mode: self.state.isNew ? .new : .update)
            self.store.dispatch(.editor(action))
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("Save").bold()
          }
          .disabled(!state.isValid)
        )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

#if DEBUG
struct ComposerView_Previews: PreviewProvider {
  static var previews: some View {
    ComposerView(mode: .new)
  }
}
#endif
