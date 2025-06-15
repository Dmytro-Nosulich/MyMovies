//
//  SceneDelegate.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)

    let userService = UserServiceAssembly.shared
    if userService.user != nil {
      let homeView = Home.build()
      window.rootViewController = homeView
    } else {
      let signUpView = SignUp.build(with: window)
      window.rootViewController = signUpView
    }
    window.makeKeyAndVisible()
    self.window = window
  }
}
