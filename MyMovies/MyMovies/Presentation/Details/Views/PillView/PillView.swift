//
//  PillView.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

final class PillView: UIView {

  // MARK: - Properties

  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }

  @IBOutlet private weak var titleLabel: UILabel!

  // MARK: - Life cycle

  static func newWith(title: String) -> PillView {
    let view = PillView.fromXib()
    view.title = title
    return view
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    updateCornerRadius()
  }
}

// MARK: - Helpers

private extension PillView {

  func updateCornerRadius() {
    self.layer.cornerRadius = self.frame.height / 2
  }
}
