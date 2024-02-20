//
//  EditAccountView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct EditAccountView: View {
  let store: Store<EditAccount.State, EditAccount.Action>

  let mode: EditAccount.Mode

  var body: some View {
    NavigationStack {
      EditAccountForm(store: store)
        .navigationTitle(store.isNew ? "New Account" : "Edit Account")
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button {
              let action = EditAccount.Action.save(store.snapshot, mode: store.isNew ? .new : .update)
              store.send(action)
            } label: {
              Text("Save").bold()
            }
            .disabled(!store.isValid)
          }
          ToolbarItem(placement: .cancellationAction) {
            Button {
              store.send(.delegate(.dismiss))
            } label: {
              Text("Cancel")
            }
          }
        }
        .task {
          store.send(.loadAccounts)
        }
    }
  }
}
