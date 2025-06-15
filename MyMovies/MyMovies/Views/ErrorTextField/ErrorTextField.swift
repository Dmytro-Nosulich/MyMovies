//
//  ErrorTextField.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import UIKit

final class ErrorTextField: UIView {

  // MARK: - Properties

  var isSecure: Bool = false {
    didSet {
      handleNewIsSecure()
    }
  }
  var placeholder: String? {
    didSet {
      handleNewPlaceholder()
    }
  }
  var text: String? {
    get {
      textField.text
    }
    set {
      textField.text = newValue
    }
  }
  var errorText: String? {
    didSet {
      handleNewErrorText()
    }
  }

  var textDidChange: ((ErrorTextField) -> Void)?

  @IBOutlet weak var textField: UITextField!
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var errorLabel: UILabel!
  @IBOutlet private weak var switchSecureButton: UIButton!

  private var isTextFieldSecure: Bool = false

  // MARK: - Life cycle

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    mainInit()
  }

  // MARK: - User Actions

  @IBAction
  private func switchSecureButtonDidTap() {
    isTextFieldSecure.toggle()
    switchSecureState()
  }

  @IBAction func textFieldTextDidChange() {
    textDidChange?(self)
  }

  @IBAction
  private func didTapBackground() {
    textField.becomeFirstResponder()
  }
}

// MARK: - Helpers

private extension ErrorTextField {

  func mainInit() {
    loadNib()
    contentView.layer.cornerRadius = 16
    contentView.layer.shadowRadius = 5
    contentView.layer.shadowOpacity = 0.12
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
    self.backgroundColor = .systemBackground
  }

  func loadNib() {
    Bundle.main.loadNibNamed(String(describing: Self.self), owner: self)
    self.addSubview(contentView)
    contentView.setContainerConstraints()
  }

  func handleNewIsSecure() {
    isTextFieldSecure = isSecure
    switchSecureButton.isHidden = !isSecure
    switchSecureState()
  }

  func switchSecureState() {
    textField.isSecureTextEntry = isTextFieldSecure
    // Here should be changed 'switchSecureButton' icon, but I haven't found it in Figma project
    switchSecureButton.alpha = isTextFieldSecure ? 1 : 0.5
  }

  func handleNewPlaceholder() {
    textField.placeholder = placeholder
  }

  func handleNewErrorText() {
    errorLabel.text = errorText
    errorLabel.isHidden = errorText.isNilOrEmpty
  }
}

// MARK: - UITextFieldDelegate

extension ErrorTextField: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
