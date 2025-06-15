//
//  MovieCell.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import UIKit

final class MovieCell: UITableViewCell {

  // MARK: - Properties

  static let identifier = "MovieCell"

  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var infoStackView: UIStackView!
  @IBOutlet private weak var releaseYearLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var ratingView: RatingView!
  @IBOutlet private weak var favoriteButton: UIButton!

  private var movie: MovieViewModel?
  private var favoriteToggleHandler: ((MovieViewModel) -> Void)?

  // MARK: - Life cycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configureView()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    movie = nil
    posterImageView.image = nil
  }

  // MARK: - User actions

  @IBAction
  private func didTapFavoriteButton() {
    guard let movie else { return }
    favoriteToggleHandler?(movie)
    configureFavoriteButton()
  }

  // MARK: - Public methods

  func configureWith(movie: MovieViewModel, favoriteToggleHandler: @escaping (MovieViewModel) -> Void) {
    self.movie = movie
    self.favoriteToggleHandler = favoriteToggleHandler

    releaseYearLabel.text = movie.releaseYear
    titleLabel.text = movie.title
    configureFavoriteButton()
    ratingView.rating = movie.rating

    movie.posterDownloader?.download { [weak self] downloader in
      self?.handleImageDownload(with: downloader)
    }
  }
}

// MARK: - Helpers

private extension MovieCell {

  func configureView() {
    posterImageView.layer.cornerRadius = 10
    infoStackView.setCustomSpacing(3, after: titleLabel)
    ratingView.backgroundColor = .clear
  }

  func handleImageDownload(with downloader: ImageDownloader) {
    guard downloader.url == movie?.posterDownloader?.url else { return }
    posterImageView.image = downloader.image
  }

  func configureFavoriteButton() {
    guard let movie else { return }
    let favoriteImageName = movie.isFavorite ? "favorite_on" : "favorite_off"
    favoriteButton.setImage(UIImage(named: favoriteImageName), for: .normal)
  }
}
