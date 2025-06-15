//
//  UIStackView+Utils.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

extension UIStackView {

  func clearArrangedSubviews() {
    for view in self.arrangedSubviews {
      self.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }
}
