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
  private let label: Label
  private let accounts: [String: [Alfheim.Account]]

  init(_ accounts: [String: [Alfheim.Account]],
       selection: Binding<Alfheim.Account?>,
       label: Label) {
    self.accounts = accounts
    self.selection = selection
    self.label = label
  }

  var body: some View {
    ZStack {
      label
      NavigationLink(destination: content, isActive: $isContentActive) {
        EmptyView()
      }
      .buttonStyle(PlainButtonStyle())
      .frame(width: 0)
      .opacity(0.0)
    }
  }

  private var content: some View {
    List {
      ForEach(Array(accounts.keys), id: \.self) { key in
        Section(
          header:
            Text(key.uppercased())
        ) {
          ForEach(accounts[key] ?? [], id: \.id) { acc in
            Button(action: {
              self.selection.wrappedValue = acc
              self.isContentActive = false
            }) {
              Text(acc.name)
            }
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
}


struct AccountList: View {
  var body: some View {
    List {
      Section(
        header:
          Text("ASSETS")
      ) {
        Text("Checking")
      }

      Section(
        header:
          Text("LIABLITIES")
      ) {
        Text("Credit Card")
      }

      Section(
        header:
          Text("INCOME")
      ) {
        Text("Salary")
      }

      Section(
        header:
          Text("EXPENSES")
      ) {
        Text("Food & Drink")
      }

      Section(
        header:
          Text("EQUITY")
      ) {
        Text("Opening Balance")
      }
    }
    .listStyle(InsetGroupedListStyle())
  }

}
