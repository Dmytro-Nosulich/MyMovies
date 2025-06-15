//
//  KeyFactView.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

final class KeyFactView: UIView {

  // MARK: - Properties

  @IBOutlet private var contentView: UIView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var valueLabel: UILabel!

  // MARK: - Life cycle

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
  }

  // MARK: - Public methods

  func setTitle(_ title: String, value: String) {
    titleLabel.text = title
    valueLabel.text = value
  }
}

// MARK: - Helpers

private extension KeyFactView {

  func configureView() {
    loadNib()
    self.layer.cornerRadius = 12
    self.clipsToBounds = true
  }

  func loadNib() {
    Bundle.main.loadNibNamed(String(describing: Self.self), owner: self)
    self.addSubview(contentView)
    contentView.setContainerConstraints()
  }
}
