//
//  Store.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

//import Foundation
//import Combine
//import CoreData

/*
class AppStore: ObservableObject {
  @Published var state: AppState
  private let reducer: AppReducer

  var context: NSManagedObjectContext

  private var disposeBag = Set<AnyCancellable>()

  init(state: AppState = AppState(),
       reducer: AppReducer = AppReducer(),
       moc: NSManagedObjectContext) {
    self.state = state
    self.reducer = reducer
    self.context = moc

    binding()
  }

  private func binding() {
    state.editor.validator.isValid
      .dropFirst()
      .removeDuplicates()
      .sink { isValid in
        self.dispatch(.editor(.validate(valid: isValid)))
      }
      .store(in: &disposeBag)

    state.payment.validator.isValid
      .dropFirst()
      .removeDuplicates()
      .sink { isValid in
        self.dispatch(.payment(.validate(valid: isValid)))
      }
      .store(in: &disposeBag)

    Persistences.Account(context: context)
      .fetchAllPublisher()
      //.map { Alne.Account($0) }
      .removeDuplicates()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Load account finished")
        case .failure(let error):
          print("Load account failed: \(error)")
        }
      }, receiveValue: { accounts in
        self.dispatch(.account(.loaded(accounts)))
      })
      .store(in: &disposeBag)

    Persistences.Transaction(context: context)
      .fetchAllPublisher()
      .removeDuplicates()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Load account finished")
        case .failure(let error):
          print("Load account failed: \(error)")
        }
      }, receiveValue: { transactions in
        self.dispatch(.transactions(.updated(transactions)))
      })
      .store(in: &disposeBag)

    Persistences.Payment(context: context)
      .fetchAllPublisher()
      .removeDuplicates()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Load account finished")
        case .failure(let error):
          print("Load account failed: \(error)")
        }
      }, receiveValue: { payments in
        let sorted = payments.sorted(by: { $0.transactions?.count ?? 0 > $1.transactions?.count ?? 0 })
        self.dispatch(.payment(.updated(sorted)))
      })
      .store(in: &disposeBag)

    Persistences.Emoji(context: context)
      .fetchAllPublisher()
      .map { $0.compactMap(Catemoji.init(emoji:)) }
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Load account finished")
        case .failure(let error):
          print("Load account failed: \(error)")
        }
      }, receiveValue: { emojis in
        self.dispatch(.catemoji(.updated(emojis)))
      })
      .store(in: &disposeBag)
  }

  func dispatch(_ action: AppAction) {
    print("[ACTION]: \(action)")
    let result = reducer.reduce(state: state, action: action)
    state = result.0
    if let command = result.1 {
      print("[COMMAND]: \(command)")
      command.execute(in: self)
    }
  }
}
*/
