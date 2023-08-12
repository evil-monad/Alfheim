//
//  HomeView.swift
//  Alfheim
//
//  Created by alex.huo on 2022/12/5.
//  Copyright © 2022 blessingsoft. All rights reserved.
//

import SwiftUI
import Domain
import ComposableArchitecture

struct HomeView: View {
  let store: StoreOf<Home>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      List(selection: vs.binding(get: \.selection, send: { .select($0) })) {
        Section {
          QuickMenu(store: store)
            .listRowBackground(Color(.systemGroupedBackground))
            .buttonStyle(.plain)
            .onTapGesture {}
            .onLongPressGesture {}
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color(.systemGroupedBackground))
        .buttonStyle(.plain)

        Section {
          OutlineGroup(vs.rootAccounts, children: \.children) { account in
            AccountLink(account, selection: nil)
              .contextMenu(account.root ? nil : ContextMenu {
                Button {
                  vs.send(.edit(account))
                } label: {
                  Label("Edit", systemImage: "pencil.circle")
                }

                Button(role: .destructive) {
                  vs.send(.delete(account))
                } label: {
                  Label("Delete", systemImage: "trash.circle")
                    .foregroundColor(.red)
                }
              }
              )
          }
        } header: {
          Text("Accounts").font(.headline).foregroundColor(.primary)
        }
        .foregroundColor(.primary)
        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16))
        .buttonStyle(.plain)
        .tint(Color(UIColor.systemGray4))
      }
      .sheet(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /Home.Destination.State.edit,
        action: Home.Destination.Action.edit
      ) { store in
        EditAccountView(store: store, mode: .edit)
//        NavigationStack {
//          EditAccountForm(store: store)
//            .navigationTitle("Edit Account")
//            .toolbar {
//              ToolbarItem(placement: .confirmationAction) {
//                Button {
//                  //let action = EditAccount.Action.save(vs.snapshot, mode: vs.isNew ? .new : .update)
//                  //vs.send(action)
//                } label: {
//                  Text("Save").bold()
//                }
//                //.disabled(!vs.edit.isValid)
//              }
//              ToolbarItem(placement: .cancellationAction) {
//                Button {
//                  vs.send(.cancelEdit)
//                } label: {
//                  Text("Cancel")
//                }
//              }
//            }
//        }
      }
    }
  }
}

private struct AccountRow: View {
  let account: Domain.Account
  private let isSelected: Bool

  init(_ account: Domain.Account, selection: Home.Selection?) {
    self.account = account
    if case let .some(.account(lhs)) = selection {
      self.isSelected = lhs.id == account.id
    } else {
      self.isSelected = false
    }
  }

  var body: some View {
    HStack {
      Text("\(account.emoji ?? "") \(account.name)")
      Spacer()
      Image(systemName: "chevron.forward")
        .opacity(account.hasChildren ? 0 : 1)
        .font(.caption.weight(.bold))
        .foregroundColor(Color(UIColor.tertiaryLabel))
    }
    .background(Color(UIColor.systemGray4).opacity(isSelected ? 1.0 : 0.0))
    .background(Color(UIColor.secondarySystemGroupedBackground))
    .contentShape(Rectangle())
  }
}

private struct AccountLink: View {
  let account: Domain.Account
  private let isSelected: Bool

  init(_ account: Domain.Account, selection: Home.Selection?) {
    self.account = account
    if case let .some(.account(lhs)) = selection {
      self.isSelected = lhs.id == account.id
    } else {
      self.isSelected = false
    }
  }

  var body: some View {
    NavigationLink(value: Home.Selection.account(account)) {
      Text("\(account.emoji ?? "") \(account.name)")
    }
    .foregroundColor(.primary)
  }
}

struct QuickMenu: View {
  let store: StoreOf<Home>
  private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 18), count: 2)

  var body: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      LazyVGrid(columns: columns, spacing: 18) {
        ForEach(vs.menus) { item in
          MenuRow(item, selection: vs.selection)
            .onTapGesture {
              vs.send(.select(.menu(item)))
            }
        }
      }
      .onLongPressGesture {}
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
          // selection = nil
          vs.send(.select(nil))
        }
      }
    }
  }
}

struct MenuRow: View {
  let item: Home.MenuItem
  private let isSelected: Bool

  init(_ item: Home.MenuItem, selection: Home.Selection?) {
    self.item = item
    if case let .some(.menu(lhs)) = selection {
      self.isSelected = lhs.id == item.id
    } else {
      self.isSelected = false
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Image(systemName: item.symbol).font(.title2).foregroundColor(item.color)
        Spacer()
        Text(item.value).font(.subheadline)
      }
      Text(item.name).font(.callout).fontWeight(.medium)
    }
    .padding(12)
    .background(Color(UIColor.systemGray4).opacity(isSelected ? 1.0 : 0.0))
    .background(Color(UIColor.secondarySystemGroupedBackground))
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }
}

extension EdgeInsets {
  static let `default` = EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16)
}

extension Home.MenuItem {
  var color: Color {
    switch filter {
    case .all: return Color.red
    case .uncleared: return Color.gray
    case .repeating: return Color.yellow
    case .flagged: return Color.blue
    }
  }
}

#if DEBUG

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Section(header: EmptyView()) {
        QuickMenu(
          store: Store(initialState: Home.State()) {
            Home()
          }
        )
        .listRowBackground(Color.clear)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())

      Section(header: Text("Accounts").font(.headline).foregroundColor(.primary)) {
        Text("ABC")
      }
    }.listStyle(.insetGrouped)
  }
}

#endif
