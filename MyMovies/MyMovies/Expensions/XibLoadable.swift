//
//  UIView+Utils.swift
//  MyMovies
//
//  Created by Dmytro on 11.06.25.
//

import UIKit

protocol XibLoadable {}

extension XibLoadable where Self: UIView {

  static func fromXib() -> Self {
    let dynamicMetatype = Self.self
    let bundle = Bundle(for: dynamicMetatype)
    let nib = UINib(nibName: "\(dynamicMetatype)", bundle: bundle)
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError("Could not load view from nib file: '\(dynamicMetatype)'.")
    }
    return view
  }
}

extension XibLoadable where Self: UIViewController {

  static func fromXib() -> Self {
    let dynamicMetatype = Self.self
    let bundle = Bundle(for: dynamicMetatype)
    let newViewController = Self(nibName: "\(dynamicMetatype)", bundle: bundle)
    return newViewController
  }
}
