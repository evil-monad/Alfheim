//
//  PaymentEditor.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/25.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct PaymentComposer: View {
//  // alternative dismiss
//  @Environment(\.presentationMode) var presentationMode
//  @EnvironmentObject var store: AppStore
//
//  private var state: AppState.Payment {
//    store.state.payment
//  }
//
//  let mode: PaymentEditor.Mode
//
//  var body: some View {
//    NavigationView {
//      PaymentEditor()
//        .navigationBarTitle(self.state.isNew ? "New Payment" : "Edit Payment")
//        .navigationBarItems(
//          leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//          }) {
//            Text("Cancel")
//          },
//          trailing: Button(action: {
//            let action = AppAction.Payment.save(self.state.validator.payment, mode: self.state.isNew ? .new : .update)
//            self.store.dispatch(.payment(action))
//            self.presentationMode.wrappedValue.dismiss()
//          }) {
//            Text("Save")
//          }
//          .disabled(!state.isValid)
//        )
//    }
//    .navigationViewStyle(StackNavigationViewStyle())
//  }
//}
//
//struct PaymentEditor: View {
//  @EnvironmentObject var store: AppStore
//
//  private var binding: Binding<AppState.Payment> {
//    $store.state.payment
//  }
//
//  enum Mode {
//    case new
//    case edit
//  }
//
//  var body: some View {
//    List {
//      Section(header: Spacer()) {
//        TextField("Name", text: binding.validator.name)
//        TextField("Description", text: binding.validator.description)
//          //.font(.system(size: 16, weight: .thin))
//          .foregroundColor(.gray)
//      }
//
//      Section(header: Spacer()) {
//        Picker(selection: binding.validator.kind, label: Text("Kind")) {
//          ForEach(Alne.Payment.Kind.allCases, id: \.self) {
//            Text($0.name).tag($0.rawValue)
//          }
//        }
//      }
//    }
//    .listStyle(InsetGroupedListStyle())
//  }
//}
//
//#if DEBUG
//struct PaymentEditor_Previews: PreviewProvider {
//  static var previews: some View {
//    PaymentEditor()
//  }
//}
//#endif
