//
//  AppCommand+Catemoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppCommands {
  struct CreateCatemojiCommand: AppCommand {
    let catemoji: Alne.Catemoji

    func execute(in store: AppStore) {
      let persistence = Persistences.Emoji(context: store.context)

      guard !persistence.exists(withText: catemoji.emoji) else {
        store.dispatch(.catemoji(.addDone(.failure(.alreadyExists))))
        return
      }

      let object = Alfheim.Emoji(context: store.context)
      object.category = catemoji.category.name
      object.text = catemoji.emoji

      do {
        try persistence.save()
      } catch {
        store.dispatch(.catemoji(.addDone(.failure(.addFailed(error)))))
        print("Update account failed: \(error)")
      }
    }
  }

  struct DeleteCatemojiCommand: AppCommand {
    let catemojis: [Alne.Catemoji]

    func execute(in store: AppStore) {
      guard !catemojis.isEmpty else {
        return
      }

      let persistence = Persistences.Emoji(context: store.context)

      catemojis.forEach { catemoji in
        if let object = persistence.emoji(withText: catemoji.emoji) {
          persistence.delete(object)
        } else {
          delete(catemoji: catemoji, persistence: persistence)
        }
      }

      do {
        try persistence.save()
      } catch {
        store.dispatch(.catemoji(.addDone(.failure(.deleteFailed(error)))))
        print("Delete emoji failed: \(error)")
      }
    }

    private func delete(catemoji: Catemoji, persistence: Persistences.Emoji) {
      guard let emojis = try? persistence.fetch(withCategory: catemoji.category.name, text: catemoji.emoji) else {
        return
      }

      emojis.forEach {
        persistence.delete($0)
      }
    }
  }
}
