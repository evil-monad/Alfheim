//
//  PaymentList.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/20.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct PaymentList: View {
//  @EnvironmentObject var store: AppStore
//
//  private var state: AppState.Payment {
//    store.state.payment
//  }
//
//  private var binding: Binding<AppState.Payment> {
//    $store.state.payment
//  }
//
//  private var tag: Tagit {
//    store.state.shared.account.tag
//  }
//
//  var body: some View {
//    List {
//      Section(header: Spacer()) {
//        ForEach(state.displayViewModels(tag: self.tag)) { viewModel in
//          PaymentRow(model: viewModel)
//            .onTapGesture {
//              self.store.dispatch(.payment(.editPayment(viewModel.payment)))
//          }
//        }
//        .onDelete { indexSet in
//          self.store.dispatch(.payment(.delete(at: indexSet)))
//        }
//        .sheet(
//          isPresented: self.binding.editingPayment,
//          onDismiss: {
//            self.store.dispatch(.payment(.editPaymentDone))
//        }) {
//          PaymentComposer(mode: .edit)
//            .environmentObject(self.store)
//        }
//      }
//    }
//    .listStyle(InsetGroupedListStyle())
//    .navigationBarTitle("Payments")
//    .navigationBarItems(
//      trailing: Button(action: {
//        self.store.dispatch(.payment(.toggleNewPayment(presenting: true)))
//      }) {
//        Image(systemName: "plus.circle").padding(.vertical).font(Font.system(size: 18)).padding(.leading)
//      }
//    )
//    .sheet(
//      isPresented: binding.isEditorPresented,
//      onDismiss: {
//        self.store.dispatch(.payment(.toggleNewPayment(presenting: false)))
//    }) {
//      PaymentComposer(mode: .new)
//        .environmentObject(self.store)
//    }
//  }
//}
//
//#if DEBUG
//struct PaymentList_Previews: PreviewProvider {
//  static var previews: some View {
//    PaymentList()
//  }
//}
//#endif
