//
//  AccountPicker.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/14.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import Domain
import Kit

/// A type that specifies the appearance and interaction of all account pickers
/// within a view hierarchy.
protocol AccountPickerStyle {
}

extension AccountPickerStyle where Self == DefaultAccountPickerStyle {
    /// The default style for account pickers.
  static var automatic: DefaultAccountPickerStyle {
    DefaultAccountPickerStyle()
  }
}

struct DefaultAccountPickerStyle: AccountPickerStyle {}

extension AccountPickerStyle where Self == CompactAccountPickerStyle {
  /// The compact style for account pickers.
  static var compact: CompactAccountPickerStyle {
    CompactAccountPickerStyle()
  }
}

struct CompactAccountPickerStyle: AccountPickerStyle {}

struct AccountPickerStyleKey: EnvironmentKey {
  static let defaultValue: AccountPickerStyle = .automatic
}

extension EnvironmentValues {
  var accountPickerStyle: AccountPickerStyle {
    get { self[AccountPickerStyleKey.self] }
    set { self[AccountPickerStyleKey.self] = newValue }
  }
}

extension View {
  func accountPickerStyle<S>(_ style: S) -> some View where S : AccountPickerStyle {
    return environment(\.accountPickerStyle, style)
  }
}

struct AccountPicker<Label>: View where Label: View {
  // When using env within NavigationStack will cause binding changed
  //@Environment(\.accountPickerStyle) private var style

  private var style: AccountPickerStyle = .automatic
  private let selection: Binding<Domain.Account.Summary?>
  private let label: Label
  private let accounts: [String: [Domain.Account]]

  init(style: AccountPickerStyle = DefaultAccountPickerStyle(),
       accounts: [String: [Domain.Account]],
       selection: Binding<Domain.Account.Summary?>,
       @ViewBuilder label: @escaping () -> Label) {
    self.style = style
    self.accounts = accounts
    self.selection = selection
    self.label = label()
  }

  @ViewBuilder
  var body: some View {
    if style is DefaultAccountPickerStyle {
      NavigationLink(destination: content) {
        HStack {
          label
          Spacer()
          Text(selection.wrappedValue?.name ?? "")
        }
      }
    } else {
      ZStack {
        label

        NavigationLink(destination: content) {
          EmptyView()
        }
        .buttonStyle(.plain)
        .frame(width: 0)
        .opacity(0.0)
      }
    }
  }

  private var content: some View {
    Hierarchy(accounts) { account in
      Button {
        selection.wrappedValue = account.summary
      } label: {
        HStack {
          Group {
            if selection.wrappedValue == account.summary {
              Image(systemName: "checkmark").foregroundColor(.blue)
            } else {
              Text("\(account.emoji ?? "")")
            }
          }
          .frame(width: 22)
          Text(account.name)
        }
      }
    } header: { group in
      if style is DefaultAccountPickerStyle {
        EmptyView()
      } else {
        Text(group.uppercased())
      }
    }
    .listStyle(.insetGrouped)
  }
}

struct HierarchyAccountPicker<Label>: View where Label: View {
  private let accounts: [String: [Domain.Account]]

  @ViewBuilder
  private let label: (Domain.Account) -> Label

  init(_ accounts: [String: [Domain.Account]],
       @ViewBuilder label: @escaping (Domain.Account) -> Label) {
    self.accounts = accounts
    self.label = label
  }

  var body: some View {
    Hierarchy(accounts) { account in
      label(account)
    } header: { _ in
      EmptyView()
    }
    .listStyle(.insetGrouped)
  }
}

/// Only for account picker
private struct Hierarchy<RowContent, Header>: View where RowContent: View, Header: View {
  private let groupAccount: [String: [Domain.Account]]
  private let rowContent: (Domain.Account) -> RowContent
  private let header: (String) -> Header

  init(_ data: [String: [Domain.Account]],
       rowContent: @escaping (Domain.Account) -> RowContent,
       @ViewBuilder header: @escaping (String) -> Header) {
    self.groupAccount = data
    self.rowContent = rowContent
    self.header = header
  }

  var body: some View {
    List {
      ForEach(Array(groupAccount.keys).sorted(), id: \.self) { group in
        Section {
          let account: [Domain.Account] = groupAccount[group] ?? [] // TODO: filter root
          RecursiveView(account, children: \.children, rowContent: rowContent)
        } header: {
          header(group)
        }
      }
    }
  }
}

extension Hierarchy where RowContent: View, Header == EmptyView {
  init(_ data: [String: [Domain.Account]],
       rowContent: @escaping (Domain.Account) -> RowContent) {
    self.groupAccount = data
    self.rowContent = rowContent
    self.header = { _ in EmptyView() }
  }
}
