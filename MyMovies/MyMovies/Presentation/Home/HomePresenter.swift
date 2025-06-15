//
//  HomePresenter.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import Foundation

enum PresenterLoadingState {
  case none
  case loading
  case retry(_ message: String)
}

protocol HomeInput: AnyObject {

  func setTitle(_ title: String, with userName: String)
  func reloadData()
  func setLoadingState(_ state: PresenterLoadingState)
}

protocol HomeOutput {

  var view: HomeInput! { get set }
  var tableSections: [HomeTableSection] { get }
  var favoriteMovies: [MovieViewModel] { get }

  func handleViewDidLoad()
  func handleViewWillAppear()
  func handleSearchDidTap()
  func handleDidSelectFavorite(_ movie: MovieViewModel)
  func handleDidSelectStuffPickAt(index: Int)
  func handleDidToggleFavorite(for movie: MovieViewModel)
  func stuffPickMovieAt(index: Int) -> MovieViewModel
  func handleRetryLoadingState()
}

final class HomePresenter: HomeOutput {

  // MARK: - Properties

  unowned var view: (any HomeInput)!
  private(set) var tableSections: [HomeTableSection] = []
  private(set) var favoriteMovies: [MovieViewModel] = []

  private let router: HomeRouter
  private let userService: UserService
  private let moviesService: MoviesService
  private let favoritesService: FavoritesService
  private let appConfigurations: AppConfigurations
  private let imageDownloaderProvider: any ImageDownloaderProvider

  private var stuffPicksMovies: [MovieViewModel] = []

  // MARK: - Life cycle

  init(router: HomeRouter, dependencyContainer: DependencyContainer) {
    self.router = router
    self.userService = dependencyContainer.userService
    self.moviesService = dependencyContainer.moviesService
    self.favoritesService = dependencyContainer.favoritesService
    self.appConfigurations = dependencyContainer.appConfigurations
    self.imageDownloaderProvider = dependencyContainer.imageDownloaderProvider
  }

  // MARK: - HomeOutput

  func handleViewDidLoad() {
    setTitle()
  }

  func handleViewWillAppear() {
    buildTableSections()
  }

  func handleSearchDidTap() {
    router.didSelectSearchMovies()
  }

  func handleDidSelectFavorite(_ movie: MovieViewModel) {
    guard let movie = favoritesService.savedMovies.first(where: { $0.id == movie.id }) else { return }
    router.didSelectMovie(movie)
  }

  func handleDidSelectStuffPickAt(index: Int) {
    let movieVM = stuffPicksMovies[index]
    guard let movie = moviesService.stuffPicks.first(where: { $0.id == movieVM.id }) else { return }
    router.didSelectMovie(movie)
  }

  func handleDidToggleFavorite(for movie: MovieViewModel) {
    if movie.isFavorite {
      favoritesService.removeMovieWith(id: movie.id)
    } else {
      guard let movie = moviesService.stuffPicks.first(where: { $0.id == movie.id }) else { return }
      favoritesService.saveMovie(movie)
    }

    buildTableSections()
  }

  func stuffPickMovieAt(index: Int) -> MovieViewModel {
    stuffPicksMovies[index]
  }

  func handleRetryLoadingState() {
    loadStuffPicks()
  }
}

// MARK: - Helpers

private extension HomePresenter {

  func setTitle() {
    let title = "Hello 👋\n"
    var userNameValue = "there"
    if let userName = userService.user?.name {
      userNameValue = userName
    }
    view.setTitle(title, with: userNameValue)
  }

  func buildTableSections() {
    buildFavoriteMovies()
    prepareStuffPicks()

    tableSections = [
      .stuffPicks(HomeTableSection.stuffPicksTitle, stuffPicksMovies.count)
    ]
    if !favoriteMovies.isEmpty {
      tableSections.insert(.favorites(HomeTableSection.favoritesTitle), at: 0)
    }
    view.reloadData()
  }

  func buildFavoriteMovies() {
    favoriteMovies = favoritesService.savedMovies.map {
      buildMovieViewModel(from: $0)
    }
  }

  func prepareStuffPicks() {
    buildStuffPicks()

    if stuffPicksMovies.isEmpty {
      loadStuffPicks()
    }
  }

  func buildStuffPicks() {
    stuffPicksMovies = moviesService.stuffPicks.map {
      buildMovieViewModel(from: $0)
    }
  }

  func buildMovieViewModel(from movie: Movie) -> MovieViewModel {
    MovieViewModelBuilder(
      movie: movie,
      favoritesService: favoritesService,
      appConfigurations: appConfigurations,
      imageDownloaderProvider: imageDownloaderProvider
    ).build()
  }

  func loadStuffPicks() {
    view.setLoadingState(.loading)
    Task {
      let result = await moviesService.fetchStuffPicks()

      await handleStuffPicksResult(result)
    }
  }

  @MainActor
  func handleStuffPicksResult(_ result: Result<[Movie], Error>) {
    switch result {
    case .success:
      view.setLoadingState(.none)
      buildTableSections()
    case .failure(let error):
      view.setLoadingState(.retry(error.localizedDescription))
    }
  }
}
