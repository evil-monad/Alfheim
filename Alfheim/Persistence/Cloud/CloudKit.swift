//
//  CloudKit.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/16.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class CloudKit {

  func reloadContainer() -> NSPersistentCloudKitContainer {
    let persistent = UserDefaults.standard.bool(forKey: "com.alfheim.cloudkit.enabled")
    return initializeContainer(persistent: persistent)
  }

  func initializeContainer(persistent: Bool) -> NSPersistentCloudKitContainer {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */
    let container = NSPersistentCloudKitContainer(name: "Alfheim")

    container.persistentStoreDescriptions.forEach { description in
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

      if !persistent {
        description.cloudKitContainerOptions = nil
      } else {
        // TBD: Should set cloudKitContainerOptions here?
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

    /*
    do {
        try container.viewContext.setQueryGenerationFrom(.current)
    } catch {
        fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
    }*/

    // Observe Core Data remote change notifications.
    NotificationCenter.default.addObserver(
      self, selector: #selector(CloudKit.storeRemoteChange(_:)),
      name: .NSPersistentStoreRemoteChange, object: container)

    return container
  }

  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */
    let container = NSPersistentCloudKitContainer(name: "Alfheim")

    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("###\(#function): Failed to retrieve a persistent store description.")
    }

    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

    if !UserDefaults.standard.bool(forKey: "com.alfheim.cloudkit.enabled") {
      description.cloudKitContainerOptions = nil
    }

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

    // initialize the CloudKit schema
    let id = "iCloud.com.xspyhack.Alfheim"
    let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)

    //container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    container.viewContext.automaticallyMergesChangesFromParent = true

    return container
  }()

  func initializeScheme() {
    do {
      try persistentContainer.initializeCloudKitSchema(options: .printSchema)
    } catch {
      print("Initialize the CloudKit scheme failed: \(error)")
      assertionFailure(error.localizedDescription)
    }
  }

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
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

  // Delete the zone in iCloud
  func deleteZone() {
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

extension CloudKit {
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
      print("###\(#function): Merging changes from the other persistent store coordinator.")

      // Process persistent history to merge changes from other
      // TODO: - alex
    }
}
