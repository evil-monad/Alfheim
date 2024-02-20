//
//  EditorView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Kit
import Alne

struct EditorView: View {
  @Bindable var store: Store<Editor.State, Editor.Action>
  @FocusState private var focus: Editor.State.FocusField?

  enum Mode {
    case new
    case edit
  }

  var body: some View {
    List {
      Section {
        HStack {
          AccountPicker(
            style: .compact,
            accounts: store.state.groupedRootAccounts,
            selection: $store.source
          ) {
            selectedAccount(store.source)
          }
          .accountPickerStyle(.compact)

          TextField(
            "0.00",
            text: $store.amount
          )
          .focused($focus, equals: .amount)
          .keyboardType(.decimalPad)
          .multilineTextAlignment(.trailing)
          .padding(.trailing, -2.0)
          .frame(minWidth: 150)

          Text("\(store.currency.symbol)")
            .foregroundColor(.gray)
            .opacity(0.8)
            .padding(.trailing, -2.0)
        }
        HStack {
          AccountPicker(
            style: .compact,
            accounts: store.state.groupedRootAccounts,
            selection: $store.target
          ) {
            selectedAccount(store.target)
          }
          .accountPickerStyle(.compact)
          Spacer()
          if let amount = Double(store.amount) {
            Text((-amount).formatted(.number.precision(.fractionLength(2))))
              .foregroundColor(.gray)
              .opacity(0.8)
              .multilineTextAlignment(.trailing)
              .padding(.trailing, -2.0)
          } else {
            Text("0.00")
              .foregroundColor(.gray)
              .opacity(0.8)
              .multilineTextAlignment(.trailing)
              .padding(.trailing, -2.0)
          }
          Text("\(store.currency.symbol)")
            .foregroundColor(.gray)
            .opacity(0.8)
            .padding(.trailing, -2.0)
        }
      }

      Section {
        DatePicker(
          selection: $store.date,
          in: ...Date(),
          displayedComponents: [.date, .hourAndMinute]
        ) {
          Text("Date")
        }

        Field("Notes") {
          TextField(
            "Notes",
            text: $store.notes
          )
          .multilineTextAlignment(.trailing)
          .focused($focus, equals: .notes)
        }
      }

      Section {
        Field("Payee") {
          TextField(
            "McDonalds",
            text: $store.payee
          )
          .multilineTextAlignment(.trailing)
          .focused($focus, equals: .payee)
        }
        Field("Number") {
          TextField(
            "20200202",
            text: $store.number
          )
          .multilineTextAlignment(.trailing)
          .focused($focus, equals: .number)
        }
        Picker(selection: $store.repeated, label: Text("Repeat")) {
          ForEach(Repeat.allCases, id: \.self) {
            Text($0.name).tag($0)
          }
        }
        Field("Cleared") {
          Toggle(isOn: $store.cleared) {
          }
        }
      }
    }
    .listStyle(.insetGrouped)
    .onChange(of: focus) { _, focus in
      store.send(.focused(focus))
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
        self.focus = .amount
      }
    }
  }

  private func selectedAccount(_ account: Domain.Account.Summary?) -> some View {
    let padding = account != nil ? 8.0 : 0
    return Text(account?.fullName ?? "Select Account")
      .font(account != nil ? .callout : .body)
      .frame(minWidth: 60)
      .foregroundColor(account?.tagit.color)
      .padding(EdgeInsets(top: 3, leading: padding, bottom: 3, trailing: padding))
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(account?.tagit.color ?? Color.clear, lineWidth: 1)
      )
  }

  struct Field<Content: View>: View {
    let name: String
    let content: Content

    init(_ name: String, @ViewBuilder content: () -> Content) {
      self.name = name
      self.content = content()
    }

    var body: some View {
      HStack {
        Text(name)
          .foregroundColor(.primary)
        content
      }
    }
  }
}

struct AccountStyle: ViewModifier {
  var tagit: Tagit?
  var padding: CGFloat
  func body(content: Content) -> some View {
    content
      .frame(minWidth: 60)
      .padding(EdgeInsets(top: 3, leading: padding, bottom: 3, trailing: padding))
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(tagit?.color ?? Color.clear, lineWidth: 1)
      )
  }
}

extension Text {
  func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
    ModifiedContent(content: self, modifier: style)
  }
}


//#if DEBUG
//struct EditorView_Previews: PreviewProvider {
//  @State static var notes = ""
//  static var previews: some View {
//    EditorView().environmentObject(AppStore(moc: viewContext))
//  }
//}
//#endif
