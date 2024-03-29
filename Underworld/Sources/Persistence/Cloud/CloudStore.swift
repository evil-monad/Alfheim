//
//  CloudKit.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/16.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import Database
import CloudKit
import StoreKit
import SwiftUI

public final class CloudStore {
  private(set) var container: NSPersistentCloudKitContainer

  init() {
    guard let url = Bundle.database.url(forResource: "Alfheim", withExtension: "momd"),
          let model = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Can't find coredata model")
    }
    self.container = NSPersistentCloudKitContainer(name: "Alfheim", managedObjectModel: model)
  }

  public func reloadContainer() {
    let persistent = UserDefaults.standard.bool(forKey: "com.alfheim.cloudkit.enabled")
    setupContainer(persistent: persistent)
  }

  public func setupContainer(persistent: Bool) {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */

    container.persistentStoreDescriptions.forEach { description in
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

      if !persistent {
        description.cloudKitContainerOptions = nil // Close cloud sync
      } else {
        // TBD: Should set cloudKitContainerOptions here?
        /*
        let id = "iCloud.com.xspyhack.Alfheim"
        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
        description.cloudKitContainerOptions = options
         */
      }
    }

    /*
    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("###\(#function): Failed to retrieve a persistent store description.")
    }

    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

    if !persistent {
      description.cloudKitContainerOptions = nil
    } else {
      // options
      let id = "iCloud.com.xspyhack.Alfheim"
      let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
      description.cloudKitContainerOptions = options
    }
     */

    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    //container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    container.viewContext.automaticallyMergesChangesFromParent = true

    // 避免在数据导入期间应用程序产生的数据变化和导入数据不一致而可能出现的不稳定情况
    do {
        try container.viewContext.setQueryGenerationFrom(.current)
    } catch {
        fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
    }

    // Observe Core Data remote change notifications.
    NotificationCenter.default.removeObserver(self)

    NotificationCenter.default.addObserver(
      self, selector: #selector(CloudStore.storeRemoteChange(_:)),
      name: .NSPersistentStoreRemoteChange,
      object: container
    )

    NotificationCenter.default.addObserver(
      self, selector: #selector(CloudStore.storeEventChange(_:)),
      name: NSPersistentCloudKitContainer.eventChangedNotification,
      object: container
    )
  }

  public func initializeScheme() {
    do {
      // let id = "iCloud.com.xspyhack.Alfheim"
      // let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
      try container.initializeCloudKitSchema(options: .printSchema)
    } catch {
      print("Initialize the CloudKit scheme failed: \(error)")
      assertionFailure(error.localizedDescription)
    }
  }

  public func schedule<T>(_ action: @Sendable @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
    try Task.checkCancellation()
    let context = newBackgroundContext()
    return try await context.perform(schedule: .immediate) {
      try context.execute(action)
    }
  }

  public func newBackgroundContext() -> NSManagedObjectContext {
    container.newBackgroundContext()
  }

  // MARK: - Core Data Saving support
  public func saveContext() {
    guard container.viewContext.hasChanges else {
      return
    }

    do {
      try container.viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  // Delete the zone in iCloud
  public func deleteZone() {
    let identifier = "iCloud.com.xspyhack.Alfheim"
    let container = CKContainer(identifier: identifier)
    let database = container.privateCloudDatabase

    database.delete(withRecordZoneID: CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone")) { zoneID, error in
      if let error = error {
        print("deleting zone error \(error.localizedDescription)")
      }
    }
  }
}

// MARK: - Notifications

extension CloudStore {
  /**
   Handle remote store change notifications (.NSPersistentStoreRemoteChange).
   */
  @objc
  private func storeRemoteChange(_ notification: Notification) {
    print("###\(#function): Merging changes from the other persistent store coordinator.")

    // Process persistent history to merge changes from other
    // TODO: - alex
  }

  @objc
  private func storeEventChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let event = userInfo["event"] as? NSPersistentCloudKitContainer.Event
    else {
      return
    }

    print("CloudKit container event changed: \(event.type)")
  }
}

// MARK: Other Check
extension CloudStore {
  public func checkAccount() {
    Task {
      do {
        let status = try await CKContainer.default().accountStatus()
        switch status {
        case .available:
          print("iCloud account available")
        case .noAccount, .couldNotDetermine, .restricted, .temporarilyUnavailable:
          print("iCloud account not available")
        @unknown default:
          print("iCloud account not available")
        }
      } catch {
        print("Check account status failed: \(error)")
      }
    }
    /*
    CKContainer.default().accountStatus { status, error in

    }*/
  }
}
