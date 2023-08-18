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
      WithViewStore(store, observe: { $0 }) { vs in
        EditAccountForm(store: store)
          .navigationTitle(vs.isNew ? "New Account" : "Edit Account")
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button {
                let action = EditAccount.Action.save(vs.snapshot, mode: vs.isNew ? .new : .update)
                vs.send(action)
              } label: {
                Text("Save").bold()
              }
              .disabled(!vs.isValid)
            }
            ToolbarItem(placement: .cancellationAction) {
              Button {
                vs.send(.delegate(.dismiss))
              } label: {
                Text("Cancel")
              }
            }
          }
      }
      .task {
        store.send(.loadAccounts)
      }
    }
  }
}
