//
//  UserService.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import Foundation

protocol UserService {

  var user: User? { get }
  func signUpWith(name: String?, email: String)
}

final class DefaultUserService: UserService {

  // MARK: - Properties

  var user: User?

  private let defaultsService: DefaultsService

  // MARK: - Life cycle

  init(defaultsService: DefaultsService) {
    self.defaultsService = defaultsService

    user = defaultsService.retrieveItem(for: .userDetails)
  }

  // MARK: - UserService

  func signUpWith(name: String?, email: String) {
    let user = User(name: name, email: email)
    defaultsService.setItem(user, for: .userDetails)
    self.user = user
  }
}

// MARK: - Assembly

struct UserServiceAssembly {

  static let shared: UserService = DefaultUserService(
    defaultsService: DefaultsServiceAssembly.standard
  )
}
