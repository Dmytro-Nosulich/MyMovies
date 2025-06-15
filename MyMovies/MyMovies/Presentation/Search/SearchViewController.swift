//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

final class SearchViewController: UIViewController, SearchInput, XibLoadable {

  // MARK: - Properties

  var presenter: SearchOutput! {
    didSet {
      presenter.view = self
    }
  }

  @IBOutlet private weak var searchContainerView: UIView!
  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var tableView: UITableView!
  private var loadingIndicator = LoadingStateView.fromXib()

  private var movies: [MovieViewModel] {
    presenter.movies
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.handleViewWillAppear()
  }

  // MARK: - SearchInput

  func setTitle(_ title: String) {
    self.title = title
  }

  func reloadData() {
    tableView.reloadData()
  }

  func setLoadingState(_ state: PresenterLoadingState) {
    switch state {
    case .none:
      tableView.tableFooterView = nil
    case .loading:
      loadingIndicator.setState(.loading)
      tableView.tableFooterView = loadingIndicator
    case .retry(let message):
      loadingIndicator.setState(.retry(message, { [weak self] in
        self?.presenter.handleRetryLoadingState()
      }))
      tableView.tableFooterView = loadingIndicator
    }
  }

  // MARK: - User actions

  @IBAction
  private func didChangeSearchText() {
    presenter.handleSearchDidChange(searchTextField.text)
  }
}

// MARK: - Helpers

private extension SearchViewController {

  func configureView() {
    searchContainerView.layer.cornerRadius = 16
    searchContainerView.layer.shadowColor = UIColor.black.cgColor
    searchContainerView.layer.shadowOpacity = 0.12
    searchContainerView.layer.shadowRadius = 5
    searchContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)

    tableView.register(.init(nibName: "MovieCell", bundle: nil),
                       forCellReuseIdentifier: MovieCell.identifier)
  }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    movies.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as? MovieCell else {
      return UITableViewCell()
    }

    let movie = movies[indexPath.row]
    cell.configureWith(movie: movie) { [unowned self] movie in
      presenter.handleDidToggleFavorite(for: movie)
    }

    return cell
  }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.handleDidSelectMovieAt(index: indexPath.row)
  }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
