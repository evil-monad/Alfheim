//
//  AppEnvironment.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import UIKit
import CoreData
import ComposableArchitecture

typealias AppContext = NSManagedObjectContext

final class AppEnvironment {
  let decoder = JSONDecoder()
  let encoder = JSONEncoder()
  let file = FileManager.default
  let queue = DispatchQueue.main

  var context: NSManagedObjectContext?
  var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
}

extension AppEnvironment {
  static let `default` = AppEnvironment()
}

enum AppEnvironments {}

extension DependencyValues {
  var context: NSManagedObjectContext {
    get { self[ContextKey.self] }
    set { self[ContextKey.self] = newValue }
  }

  private enum ContextKey: DependencyKey {
    static let liveValue: NSManagedObjectContext = AppEnvironment.default.context!
  }
}
