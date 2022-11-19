//
//  AccountComposer.swift
//  AccountComposer
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AccountComposer: View {
  @Environment(\.dismiss) var dismiss
  let store: Store<AccountEdit.State, AccountEdit.Action>

  let mode: AccountEditor.Mode

  var body: some View {
    WithViewStore(store) { vs in
      NavigationView {
        AccountEditor(store: store)
          .navigationTitle(vs.isNew ? "New Account" : "Edit Account")
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button {
                let action = AccountEdit.Action.save(vs.snapshot, mode: vs.isNew ? .new : .update)
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
      .navigationViewStyle(.stack)
      .task {
        vs.send(.loadAccounts)
      }
    }
  }
}
