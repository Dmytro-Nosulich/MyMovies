//
//  LoginViewController.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import UIKit

final class SignUpViewController: UIViewController, SignUpInput, XibLoadable {

  // MARK: - Properties

  var presenter: SignUpOutput! {
    didSet {
      presenter.view = self
    }
  }

  @IBOutlet private weak var nameTextField: ErrorTextField!
  @IBOutlet private weak var emailTextField: ErrorTextField!
  @IBOutlet private weak var passwordTextField: ErrorTextField!
  @IBOutlet private weak var confirmPasswordTextField: ErrorTextField!

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureActions()
    presenter.handleViewDidLoad()
  }

  // MARK: - User actions

  @IBAction
  private func signUpDidTap() {
    presenter.handleSignUpDidTap()
  }

  // MARK: - LoginInput

  func configureNameInputField(_ configurations: InputFieldConfigurations) {
    configureTextField(nameTextField, with: configurations)
  }

  func configureEmailInputField(_ configurations: InputFieldConfigurations) {
    configureTextField(emailTextField, with: configurations)
  }

  func configurePasswordInputField(_ configurations: InputFieldConfigurations) {
    configureTextField(passwordTextField, with: configurations)
  }

  func configureConfirmPasswordInputField(_ configurations: InputFieldConfigurations) {
    configureTextField(confirmPasswordTextField, with: configurations)
  }
}

// MARK: - Helpers

private extension SignUpViewController {

  func configureActions() {
    nameTextField.textDidChange = { [unowned self] in presenter.handleNameDidChange($0.text) }
    emailTextField.textDidChange = { [unowned self] in presenter.handleEmailDidChange($0.text) }
    passwordTextField.textDidChange = { [unowned self] in presenter.handlePasswordDidChange($0.text) }
    confirmPasswordTextField.textDidChange = { [unowned self] in presenter.handleConfirmPasswordDidChange($0.text) }
  }

  func configureTextField(_ textField: ErrorTextField, with configurations: InputFieldConfigurations) {
    textField.placeholder = configurations.placeholder
    textField.isSecure = configurations.isSecure
    textField.errorText = configurations.errorText
    textField.textField.keyboardType = configurations.keyboardType
  }
}
