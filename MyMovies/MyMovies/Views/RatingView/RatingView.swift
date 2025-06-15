//
//  RatingView.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import UIKit

final class RatingView: UIView {

  // MARK: - Properties

  var rating: Int = 0 {
    didSet {
      updateRating()
    }
  }

  @IBOutlet private var contentView: UIView!
  @IBOutlet private var stars: [UIImageView]!

  // MARK: - Life cycle

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadNib()
    updateRating()
  }
}

// MARK: - Helpers

private extension RatingView {

  func loadNib() {
    Bundle.main.loadNibNamed(String(describing: Self.self), owner: self)
    self.addSubview(contentView)
    contentView.setContainerConstraints()
  }

  func updateRating() {
    let ratingIndex = rating - 1
    for (index, star) in stars.enumerated() {
      let imageName = index <= ratingIndex ? "star_fill" : "star_empty"
      star.image = UIImage(named: imageName)
    }
  }
}
