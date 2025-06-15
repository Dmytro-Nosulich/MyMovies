//
//  SignUpRouter.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import UIKit

protocol SignUpRouter {

  func didTapSignUpButton()
}

struct DefaultSignUpRouter: SignUpRouter {

  let window: UIWindow

  func didTapSignUpButton() {
    let homeView = Home.build()
    window.rootViewController = homeView
    UIView.transition(with: window, duration: 0.25, animations: {})
  }
}
