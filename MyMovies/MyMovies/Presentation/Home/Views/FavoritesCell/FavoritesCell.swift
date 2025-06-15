//
//  FavoritesCell.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import UIKit

class FavoritesCell: UITableViewCell {

  // MARK: - Properties

  static let identifier = "FavoritesCell"

  @IBOutlet private weak var contentStackView: UIStackView!

  private var movies: [MovieViewModel] = []
  private var movieDidTapHandler: ((MovieViewModel) -> Void)?

  // MARK: - Public methods

  func configureWith(movies: [MovieViewModel], movieDidTapHandler: @escaping (MovieViewModel) -> Void) {
    self.movies = movies
    self.movieDidTapHandler = movieDidTapHandler

    contentStackView.clearArrangedSubviews()
    for (index, movie) in movies.enumerated() {
      let view = createPosterViewAt(index: index, for: movie)
      contentStackView.addArrangedSubview(view)
    }
  }

  // MARK: - User actions

  @objc
  private func didTapPoster(_ tapGesture: UITapGestureRecognizer) {
    guard let view = tapGesture.view, view.tag < movies.count else { return }
    let movie = movies[view.tag]
    movieDidTapHandler?(movie)
  }
}

// MARK: - Helpers

private extension FavoritesCell {

  func createPosterViewAt(index: Int, for movie: MovieViewModel) -> UIView {
    let container = UIView()
    container.tag = index
    container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPoster)))
    container.heightAnchor.constraint(equalToConstant: 270).isActive = true
    container.widthAnchor.constraint(equalToConstant: 182).isActive = true

    container.layer.cornerRadius = 14
    container.layer.shadowRadius = 12
    container.layer.shadowOpacity = 0.5
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOffset = CGSize(width: 0, height: 7)

    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 14
    container.addSubview(imageView)
    imageView.setContainerConstraints()
    movie.posterDownloader?.download { [weak self] downloader in
      self?.handleImageDownload(with: downloader, for: imageView, at: index)
    }

    return container
  }

  func handleImageDownload(with downloader: ImageDownloader,
                           for imageView: UIImageView, at index: Int) {
    guard movies.count > index else { return }
    let movie = movies[index]
    if movie.posterDownloader?.url == downloader.url {
      imageView.image = downloader.image
    }
  }
}
