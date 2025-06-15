//
//  LoadingStateView.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

final class LoadingStateView: UIView {

  // MARK: - Properties

  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var messageContent: UIView!
  @IBOutlet private weak var messageLabel: UILabel!

  private var retryAction: (() -> Void)?

  // MARK: - Public methods

  func setState(_ state: State) {
    var showLoading = true
    var height: CGFloat = 40
    switch state {
    case .loading:
      break
    case let .retry(message, retryAction):
      showLoading = false
      height = 100
      messageLabel.text = message
      self.retryAction = retryAction
    }
    loadingIndicator.isHidden = !showLoading
    messageContent.isHidden = showLoading
    self.frame.size.height = height
  }

  // MARK: - User actions

  @IBAction
  private func didTapRetry() {
    retryAction?()
  }
}

extension LoadingStateView {

  enum State {
    case loading
    case retry(_ message: String, _ retryAction: () -> Void)
  }
}
