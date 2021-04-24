//
//  EditorView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct EditorView: View {
  let store: Store<AppState.Editor, AppAction.Editor>

  enum Mode {
    case new
    case edit
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        Section(header: Spacer()) {
          HStack {
            AccountPicker(
              viewStore.state.groupedAccounts,
              selection: viewStore.binding(get: { $0.source }, send: { AppAction.Editor.changed(.source($0)) }),
              label: Text(viewStore.source?.name ?? "Select Account")
            )
            TextField(
              "0.00",
              text: viewStore.binding(get: { $0.amount }, send: { AppAction.Editor.changed(.amount($0)) }))
              .keyboardType(.decimalPad)
              .multilineTextAlignment(.trailing)
              .padding(.trailing, -2.0)
              .frame(minWidth: 100)
            Text("\(viewStore.currency.symbol)")
              .foregroundColor(.gray)
              .opacity(0.8)
              .padding(.trailing, -2.0)
          }
          HStack {
            AccountPicker(
              viewStore.state.groupedAccounts,
              selection: viewStore.binding(get: { $0.target }, send: { AppAction.Editor.changed(.target($0)) }),
              label: Text(viewStore.target?.name ?? "Select Account")
            )
            Spacer()
            if let amount = Double(viewStore.amount) {
              Text("\(-amount, specifier: "%.2f")")
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
            Text("\(viewStore.currency.symbol)")
              .foregroundColor(.gray)
              .opacity(0.8)
              .padding(.trailing, -2.0)
          }
        }

        Section {
          DatePicker(
            selection: viewStore.binding(get: { $0.date }, send: { AppAction.Editor.changed(.date($0)) }),
            in: ...Date(),
            displayedComponents: [.date, .hourAndMinute]
          ) {
            Text("Date")
          }
          Field("Notes") {
            InputTextField(
              "Notes",
              text: viewStore.binding(get: { $0.notes }, send: { AppAction.Editor.changed(.notes($0)) }),
              isFirstResponder: .constant(false)
            )
            .multilineTextAlignment(.trailing)
          }
        }

        Section {
          Field("Payee") {
            InputTextField(
              "McDonalds",
              text: viewStore.binding(get: { $0.payee ?? "" }, send: { AppAction.Editor.changed(.payee($0)) }),
              isFirstResponder: .constant(false)
            )
            .multilineTextAlignment(.trailing)
          }
          Field("Number") {
            InputTextField(
              "20200202",
              text: viewStore.binding(get: { $0.number ?? "" }, send: { AppAction.Editor.changed(.number($0)) }),
              isFirstResponder: .constant(false)
            )
            .multilineTextAlignment(.trailing)
          }
          Picker(selection: viewStore.binding(get: { $0.repeated }, send: { AppAction.Editor.changed(.repeated($0)) }), label: Text("Repeat")) {
            ForEach(Repeat.allCases, id: \.self) {
              Text($0.name).tag($0)
            }
          }
          Field("Cleared") {
            Toggle(isOn: viewStore.binding(get: { $0.cleared }, send: { AppAction.Editor.changed(.cleared($0)) })) {
            }
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .onAppear {
        viewStore.send(.loadAccounts)
      }
    }
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


//#if DEBUG
//struct EditorView_Previews: PreviewProvider {
//  @State static var notes = ""
//  static var previews: some View {
//    EditorView().environmentObject(AppStore(moc: viewContext))
//  }
//}
//#endif
