//
//  MemoryStore.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class MemoryStore {
  private(set) var persistentContainer: NSPersistentContainer
  private(set) var isLoaded: Bool = false

  public init() {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */
    let container = NSPersistentContainer(name: "Memory")
    persistentContainer = container

    let baseURL = URL(fileURLWithPath: "/dev/null")
    let storeURL = baseURL.appendingPathComponent("Preview").appendingPathExtension("sqlite")
    let description = NSPersistentStoreDescription(url: storeURL)
    container.persistentStoreDescriptions = [description]

    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

    container.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      self.isLoaded = true
    }

    //container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.transactionAuthor = "Preview"

    do {
        try container.viewContext.setQueryGenerationFrom(.current)
    } catch {
        fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
    }
  }

  public func saveContext () {
    let context = persistentContainer.viewContext
    guard context.hasChanges else {
      return
    }

    do {
      try context.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
