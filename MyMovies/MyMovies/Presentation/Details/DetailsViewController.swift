//
//  DetailsViewController.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

final class DetailsViewController: UIViewController, DetailsInput, XibLoadable {

  // MARK: - Properties

  var presenter: DetailsOutput! {
    didSet {
      presenter.view = self
    }
  }

  @IBOutlet private weak var favoriteButton: UIButton!
  @IBOutlet private weak var posterContainerView: UIView!
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var ratingView: RatingView!
  @IBOutlet private weak var releaseDateLabel: UILabel!
  @IBOutlet private weak var durationLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var genresStackView: UIStackView!
  @IBOutlet private weak var overviewLabel: UILabel!
  @IBOutlet private weak var budgetFactView: KeyFactView!
  @IBOutlet private weak var revenueFactView: KeyFactView!
  @IBOutlet private weak var languageFactView: KeyFactView!
  @IBOutlet private weak var ratingFactView: KeyFactView!

  private var viewModel: MovieViewModel {
    presenter.movieViewModel
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    presenter.handleViewDidLoad()
  }

  // MARK: - DetailsInput

  func configureView() {
    updateFavoriteButton()

    viewModel.posterDownloader?.download { [weak self] downloader in
      guard let self else { return }
      self.posterImageView.image = downloader.image
    }

    ratingView.rating = viewModel.rating
    releaseDateLabel.text = viewModel.releaseDate
    durationLabel.text = viewModel.duration
    configureTitle()
    configureGenres()
    overviewLabel.text = viewModel.overview
    configureKeyFacts()
  }

  func updateFavoriteButton() {
    let favoriteImageName = viewModel.isFavorite ? "favorite_on" : "favorite_off"
    favoriteButton.setImage(UIImage(named: favoriteImageName), for: .normal)
  }

  // MARK: - User actions

  @IBAction
  private func didTapFavoriteButton() {
    presenter.handleDidTapFavorite()
  }

  @IBAction
  private func didTapCloseButton() {
    presenter.handleDidTapClose()
  }
}

// MARK: - Helpers

private extension DetailsViewController {

  func setupView() {
    posterContainerView.layer.cornerRadius = 14
    posterContainerView.layer.shadowColor = UIColor.black.cgColor
    posterContainerView.layer.shadowOpacity = 0.6
    posterContainerView.layer.shadowRadius = 15
    posterContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)

    posterImageView.layer.cornerRadius = 14
    ratingView.backgroundColor = .clear
  }

  func configureTitle() {
    var attributes = AttributeContainer()
    attributes.foregroundColor = UIColor(named: "background")
    attributes.font = UIFont.boldSystemFont(ofSize: 24)
    let title = AttributedString(viewModel.title, attributes: attributes)

    attributes.foregroundColor = UIColor(named: "mediumEmphasis")
    attributes.font = UIFont.systemFont(ofSize: 24, weight: .light)
    let userNameAttributed = AttributedString("(\(viewModel.releaseYear))", attributes: attributes)

    titleLabel.attributedText = NSAttributedString(title + " " + userNameAttributed)
  }

  func configureGenres() {
    genresStackView.clearArrangedSubviews()

    for genre in viewModel.genres {
      let pillView = PillView.newWith(title: genre)
      genresStackView.addArrangedSubview(pillView)
    }
  }

  func configureKeyFacts() {
    budgetFactView.setTitle(viewModel.keyFacts.budget.title,
                            value: viewModel.keyFacts.budget.value)
    revenueFactView.setTitle(viewModel.keyFacts.revenue.title,
                            value: viewModel.keyFacts.revenue.value)
    languageFactView.setTitle(viewModel.keyFacts.language.title,
                            value: viewModel.keyFacts.language.value)
    ratingFactView.setTitle(viewModel.keyFacts.rating.title,
                            value: viewModel.keyFacts.rating.value)
  }
}
