//
//  AccountPicker.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/14.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct AccountPicker<Label>: View where Label: View {
  @State private var isContentActive: Bool = false
  private let selection: Binding<Alfheim.Account?>
  private let label: () -> Label
  private let accounts: [String: [Alfheim.Account]]

  init(_ accounts: [String: [Alfheim.Account]],
       selection: Binding<Alfheim.Account?>,
       @ViewBuilder label: @escaping () -> Label) {
    self.accounts = accounts
    self.selection = selection
    self.label = label
  }

  var body: some View {
    ZStack {
      label()

      NavigationLink(destination: content, isActive: $isContentActive) {
        EmptyView()
      }
      .buttonStyle(.plain)
      .frame(width: 0)
      .opacity(0.0)
    }
  }

  private var content: some View {
    Hierarchy(accounts) { account in
      Button {
        selection.wrappedValue = account
        isContentActive = false
      } label: {
        HStack {
          Group {
            if let selection = selection, selection.wrappedValue == account {
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
    .listStyle(.insetGrouped)
  }
}

/// Only for account picker
private struct Hierarchy<RowContent>: View where RowContent: View {
  private let groupAccount: [String: [Alfheim.Account]]
  private let rowContent: (Alfheim.Account) -> RowContent

  init(_ data: [String: [Alfheim.Account]], rowContent: @escaping (Alfheim.Account) -> RowContent) {
    self.groupAccount = data
    self.rowContent = rowContent
  }

  var body: some View {
    List {
      ForEach(Array(groupAccount.keys).sorted(), id: \.self) { group in
        Section {
          let account: [Alfheim.Account] = groupAccount[group] ?? [] // TODO: filter root
          RecursiveView(account, children: \.optinalChildren, rowContent: rowContent)
        } header: {
          Text(group.uppercased())
        }
      }
    }
  }
}
