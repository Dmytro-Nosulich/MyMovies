//
//  SignUp.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import UIKit

struct SignUp {

  static func build(with mainWindow: UIWindow) -> UIViewController {
    let router = DefaultSignUpRouter(window: mainWindow)
    let presenter = SignUpPresenter(router: router, dependencyContainer: .init())
    let view = SignUpViewController.fromXib()
    view.presenter = presenter
    return view
  }
}
