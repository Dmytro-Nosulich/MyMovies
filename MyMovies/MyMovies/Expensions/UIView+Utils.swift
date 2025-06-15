//
//  UIView+Constraints.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import UIKit

// MARK: - Constraints

extension UIView {

  func setContainerConstraints(_ insets: UIEdgeInsets = .zero) {
    guard let superview else { return }
    self.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: self,
                       attribute: .leading,
                       relatedBy: .equal,
                       toItem: superview,
                       attribute: .leading,
                       multiplier: 1,
                       constant: insets.left).isActive = true
    NSLayoutConstraint(item: self,
                       attribute: .top,
                       relatedBy: .equal,
                       toItem: superview,
                       attribute: .top,
                       multiplier: 1,
                       constant: insets.top).isActive = true
    NSLayoutConstraint(item: self,
                       attribute: .trailing,
                       relatedBy: .equal,
                       toItem: superview,
                       attribute: .trailing,
                       multiplier: 1,
                       constant: insets.right).isActive = true
    NSLayoutConstraint(item: self,
                       attribute: .bottom,
                       relatedBy: .equal,
                       toItem: superview,
                       attribute: .bottom,
                       multiplier: 1,
                       constant: insets.bottom).isActive = true
  }
}

// MARK: - Load from Xib

extension UIView {

  static func fromXib() -> Self {
    let dynamicMetatype = Self.self
    let name = String(describing: dynamicMetatype)
    let bundle = Bundle(for: dynamicMetatype)
    guard let view = bundle.loadNibNamed(name, owner: nil)?.first as? Self else {
      fatalError("Nib not found.")
    }
    return view
  }
}
