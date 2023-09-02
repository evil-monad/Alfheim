//
//  SceneDelegate.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Features

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  private lazy var store: AppStore = {
    return AppStore(initialState: App.State()) {
      RealWorld()
        ._printChanges()
    }
  }()

  private lazy var sceneStore: ViewStore<AppState, AppAction> = ViewStore(store, observe: { $0 })

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    sceneStore.send(.lifecycle(.willConnect))

    // Start app story
    startAppStory(scene: scene, store: store)
  }

  private func startAppStory(scene: UIScene, store: AppStore) {
    let rootView = MainView(store: store)

    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: rootView)
        self.window = window
        window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    sceneStore.send(.lifecycle(.didDisconnect))
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    sceneStore.send(.lifecycle(.didBecomeActive))
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    sceneStore.send(.lifecycle(.willResignActive))
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    sceneStore.send(.lifecycle(.willEnterForeground))
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    sceneStore.send(.lifecycle(.didEnterBackground))
  }

}
