//
//  SignUpPresenter.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import Foundation

protocol SignUpInput: AnyObject {

  func configureNameInputField(_ configurations: InputFieldConfigurations)
  func configureEmailInputField(_ configurations: InputFieldConfigurations)
  func configurePasswordInputField(_ configurations: InputFieldConfigurations)
  func configureConfirmPasswordInputField(_ configurations: InputFieldConfigurations)
}

protocol SignUpOutput {

  var view: SignUpInput! { get set }

  func handleViewDidLoad()
  func handleSignUpDidTap()

  func handleNameDidChange(_ name: String?)
  func handleEmailDidChange(_ email: String?)
  func handlePasswordDidChange(_ password: String?)
  func handleConfirmPasswordDidChange(_ confirmPassword: String?)
}

final class SignUpPresenter: SignUpOutput {

  // MARK: - Properties

  unowned var view: (any SignUpInput)!

  private let router: SignUpRouter
  private let userService: UserService

  private var name: String?
  private var email: String?
  private var password: String?
  private var confirmPassword: String?

  // MARK: - Life cycle

  init(router: SignUpRouter, dependencyContainer: DependencyContainer) {
    self.router = router
    self.userService = dependencyContainer.userService
  }

  // MARK: - LoginOutput

  func handleViewDidLoad() {
    configureTextfields()
  }

  func handleSignUpDidTap() {
    if !hasInvalidFields() {
      saveUser()
      router.didTapSignUpButton()
    }
  }

  func handleNameDidChange(_ name: String?) {
    self.name = name
  }

  func handleEmailDidChange(_ email: String?) {
    self.email = email
  }

  func handlePasswordDidChange(_ password: String?) {
    self.password = password
    updateConfirmPasswordState()
  }

  func handleConfirmPasswordDidChange(_ confirmPassword: String?) {
    self.confirmPassword = confirmPassword
    updateConfirmPasswordState()
  }
}

// MARK: - Helpers

private extension SignUpPresenter {

  var nameInputFieldConfigurations: InputFieldConfigurations {
    InputFieldConfigurations(placeholder: "Name")
  }

  var emailInputFieldConfigurations: InputFieldConfigurations {
    InputFieldConfigurations(placeholder: "E-Mail Address*", keyboardType: .emailAddress)
  }

  var passwordInputFieldConfigurations: InputFieldConfigurations {
    InputFieldConfigurations(placeholder: "Password*", isSecure: true)
  }

  var confirmPasswordInputFieldConfigurations: InputFieldConfigurations {
    InputFieldConfigurations(placeholder: "Confirm Password*", isSecure: true)
  }

  func configureTextfields() {
    view.configureNameInputField(nameInputFieldConfigurations)
    view.configureEmailInputField(emailInputFieldConfigurations)
    view.configurePasswordInputField(passwordInputFieldConfigurations)
    view.configureConfirmPasswordInputField(confirmPasswordInputFieldConfigurations)
  }

  func hasInvalidFields() -> Bool {
    var isInvalidForm = false

    if email.isNilOrEmpty {
      var configs = emailInputFieldConfigurations
      configs.errorText = "E-Mail Address is required"
      view.configureEmailInputField(configs)
      isInvalidForm = true
    }

    if password.isNilOrEmpty {
      var configs = passwordInputFieldConfigurations
      configs.errorText = "Password is required"
      view.configurePasswordInputField(configs)
      isInvalidForm = true
    }

    if password != confirmPassword {
      isInvalidForm = true
    }

    updateConfirmPasswordState()

    return isInvalidForm
  }

  func updateConfirmPasswordState() {
    var configurations = confirmPasswordInputFieldConfigurations
    defer {
      view.configureConfirmPasswordInputField(configurations)
    }

    guard let confirmPassword, let password else { return }
    if password != confirmPassword {
      configurations.errorText = "Passwords don’t match"
    }
  }

  func saveUser() {
    guard let email else { return }
    userService.signUpWith(name: name, email: email)
  }
}
