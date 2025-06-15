//
//  SignUpPresenterDependencyContainer.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import Foundation

extension SignUpPresenter {

  struct DependencyContainer {
    let userService: UserService

    init(
      userService: UserService = UserServiceAssembly.shared
    ) {
      self.userService = userService
    }
  }
}
