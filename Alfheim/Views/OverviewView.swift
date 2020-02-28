//
//  OverviewView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct OverviewView: View {

  @EnvironmentObject var store: AppStore

  private var state: AppState.Overview {
    store.state.overview
  }

  private var binding: Binding<AppState.Overview.ViewState> {
    $store.state.overview.viewState
  }

  #if targetEnvironment(macCatalyst)
  var body: some View {
      SplitView()
  }
  #else
  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        ScrollView(.vertical, showsIndicators: false) {
          VStack {
            AccountCard()
              .frame(height: geometry.size.width*9/16)
              .background(
                Spacer()
                  .sheet(isPresented: self.binding.isStatisticsPresented) {
                    StatisticsView() {
                      self.store.dispatch(.overview(.toggleStatistics(presenting: false)))
                    }
                }
              )
              .onTapGesture {
                self.store.dispatch(.overview(.toggleStatistics(presenting: true)))
            }

            Spacer().frame(height: 36)

            Section(header: NavigationLink(destination: TransactionList()) {
              HStack {
                Text("Transactions").font(.system(size: 24, weight: .bold))
                Spacer()
                Image(systemName: "chevron.right")
              }
              .foregroundColor(.primary)
            }) {
              ForEach(Transaction.samples()) { transaction in
                TransactionRow(transaction: transaction)
                  .onTapGesture {
                    self.store.dispatch(.overview(.editTransaction(transaction)))
                }
              }
            }
            .sheet(item: self.binding.selectedTransaction) {
              ComposerView(transaction: $0) {
                self.store.dispatch(.overview(.editTransactionDone))
              }
            }
            /*
            .sheet(isPresented: self.binding.isEditingTransaction) {
              ComposerView(transaction: self.state.selectedTransaction) {
                self.store.dispatch(.overview(.editTransactionDone))
              }
            }
            */
          }
          .padding(20)
        }
      }
      .navigationBarTitle("Journals")
      .navigationBarItems(trailing:
        Button(action: {
          self.store.dispatch(.overview(.toggleNewTransaction(presenting: true)))
        }) {
          Text("New Transaction").bold()
        }
        .sheet(isPresented: binding.isEditorPresented) {
          ComposerView(transaction: nil) {
            self.store.dispatch(.overview(.toggleNewTransaction(presenting: false)))
          }
        }
      )
    }
  }
  #endif
}

struct SplitView: View {
  var body: some View {
    Text("Hello split view")
  }
}

extension OverviewView {
  struct AccountCard: View {

    @EnvironmentObject var store: AppStore
    private var state: AppState.Overview {
      store.state.overview
    }

    private var binding: Binding<AppState.Overview.ViewState> {
      $store.state.overview.viewState
    }

    @State private var flipped: Bool = false

    private let cornerRadius: CGFloat = 20

    var body: some View {
      ZStack {
        self.foregroundCard().opacity(flipped ? 0 : 1)
        self.backgroundCard().opacity(flipped ? 1 : 0)
      }
      .background(
        RoundedRectangle(cornerRadius: self.cornerRadius)
          .fill(Color.yellow)
          .shadow(radius: 8)
      ).rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
    }

    private func foregroundCard() -> some View {
      ZStack {
        VStack {
          HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
              Button(action: {
                self.store.dispatch(.overview(.toggleAccountDetail(presenting: true)))
              }) {
                Text(self.state.account.name)
                  .font(.system(size: 22, weight: .semibold))
                  .foregroundColor(.primary)
              }
              .sheet(isPresented: self.binding.isAccountDetailPresented) {
                AccountDetail(account: self.state.account) {
                  self.store.dispatch(.overview(.toggleAccountDetail(presenting: false)))
                }
              }

              Button(action: {
                self.store.dispatch(.overview(.switchPeriod))
              }) {
                Image(systemName: "chevron.right")
                  .resizable()
                  .frame(width: 8, height: 8)
                  .foregroundColor(.secondary).padding(.bottom, -1)
                Text(self.state.period.display).font(.callout)
                  .foregroundColor(.secondary).padding(.leading, -4)
              }
            }
            Spacer()
            Button(action: {
              self.flip(true)
            }) {
              Image(systemName: "info.circle")
                .foregroundColor(.primary)
                .padding(.top, 5)
            }
          }
          Spacer()
        }
        .padding([.leading, .top, .trailing])

        Text(state.amountText)
          .gradient(LinearGradient(
            gradient: Gradient(colors: [.pink, .purple]),
            startPoint: .leading,
            endPoint: .trailing
          ))
          .font(.system(size: 36, weight: .semibold))
          .padding(.top, 2)
      }
    }

    private func backgroundCard() -> some View {
      ZStack(alignment: .topTrailing) {
        ZStack {
          Color.yellow.cornerRadius(cornerRadius)
            .onTapGesture {
              self.flip(false)
          }
          Text(state.account.description)
            .padding()
        }

        Image(systemName: "dollarsign.circle")
          .foregroundColor(.primary)
          .padding(.top, 5)
          .padding()
      }
      .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
    }

    private func flip(_ flag: Bool) {
      withAnimation(.easeOut(duration: 0.35)) {
        self.flipped = flag
      }
    }
  }
}


#if DEBUG
struct AccountCard_Previews: PreviewProvider {
  static var previews: some View {
    OverviewView.AccountCard().environment(\.colorScheme, .dark).environmentObject(AppStore())
  }
}
#endif

#if DEBUG
struct OverviewView_Previews: PreviewProvider {
  static var previews: some View {
    OverviewView().environment(\.colorScheme, .dark).environmentObject(AppStore())
  }
}
#endif
