//
//  AppStore.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CoreData

typealias AppStore = Store<App.State, App.Action>
typealias AppContext = NSManagedObjectContext
