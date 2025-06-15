//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import UIKit

class HomeViewController: UIViewController, HomeInput, XibLoadable {

  // MARK: - Properties

  var presenter: HomeOutput! {
    didSet {
      presenter.view = self
    }
  }

  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var searchButton: UIButton!
  @IBOutlet private weak var tableView: UITableView!
  private var stuffPicksLoadingIndicator = LoadingStateView.fromXib()

  private var tableSections: [HomeTableSection] = []

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    presenter.handleViewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.handleViewWillAppear()
  }

  // MARK: - User actions

  @IBAction
  private func didTapSearchButton() {
    presenter.handleSearchDidTap()
  }

  // MARK: - HomeInput

  func setTitle(_ title: String, with userName: String) {
    var attributes = AttributeContainer()
    attributes.foregroundColor = .black
    attributes.font = UIFont.systemFont(ofSize: 16)
    let title = AttributedString("Hello 👋", attributes: attributes)

    attributes.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    let userNameAttributed = AttributedString(userName, attributes: attributes)

    titleLabel.attributedText = NSAttributedString(title + "\n" + userNameAttributed)
  }

  func reloadData() {
    tableSections = presenter.tableSections
    tableView.reloadData()
  }

  func setLoadingState(_ state: PresenterLoadingState) {
    switch state {
    case .none:
      tableView.tableFooterView = nil
    case .loading:
      stuffPicksLoadingIndicator.setState(.loading)
      tableView.tableFooterView = stuffPicksLoadingIndicator
    case .retry(let message):
      stuffPicksLoadingIndicator.setState(.retry(message, { [weak self] in
        self?.presenter.handleRetryLoadingState()
      }))
      tableView.tableFooterView = stuffPicksLoadingIndicator
    }
  }
}

// MARK: - Helpers

private extension HomeViewController {

  func configureView() {
    configureTableView()

    searchButton.layer.shadowColor = UIColor.black.cgColor
    searchButton.layer.shadowOpacity = 0.16
    searchButton.layer.shadowRadius = 15
  }

  func configureTableView() {
    tableView.register(.init(nibName: "MovieCell", bundle: nil),
                       forCellReuseIdentifier: MovieCell.identifier)
    tableView.register(.init(nibName: "FavoritesCell", bundle: nil),
                       forCellReuseIdentifier: FavoritesCell.identifier)
  }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    tableSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableSections[section] {
    case .favorites:
      return 1
    case .stuffPicks(_, let rows):
      return rows
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch tableSections[indexPath.section] {
    case .favorites:
      cell = favoritesCell()
    case .stuffPicks:
      cell = movieCell(at: indexPath.row)
    }

    return cell
  }

  func favoritesCell() -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier) as? FavoritesCell else {
      return UITableViewCell()
    }

    cell.configureWith(movies: presenter.favoriteMovies) { [unowned self] movie in
      presenter.handleDidSelectFavorite(movie)
    }

    return cell
  }

  func movieCell(at index: Int) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as? MovieCell else {
      return UITableViewCell()
    }

    let movie = presenter.stuffPickMovieAt(index: index)
    cell.configureWith(movie: movie) { [unowned self] movie in
      presenter.handleDidToggleFavorite(for: movie)
    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let container = UIView()
    container.backgroundColor = .systemBackground

    let label = UILabel()
    container.addSubview(label)
    label.setContainerConstraints(.init(top: 0, left: 30, bottom: 0, right: 0))

    switch tableSections[section] {
    case .favorites(let title):
        label.attributedText = NSAttributedString(title)
    case .stuffPicks(let title, _):
        label.attributedText = NSAttributedString(title)
    }

    label.sizeToFit()
    return container
  }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch tableSections[indexPath.section] {
    case .stuffPicks:
      presenter.handleDidSelectStuffPickAt(index: indexPath.row)
    default:
      break
    }
  }
}
