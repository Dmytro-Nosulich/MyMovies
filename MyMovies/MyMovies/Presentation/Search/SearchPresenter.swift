//
//  SearchPresenter.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import Foundation

protocol SearchInput: AnyObject {

  func setTitle(_ title: String)
  func reloadData()
  func setLoadingState(_ state: PresenterLoadingState)
}

protocol SearchOutput {

  var view: SearchInput! { get set }
  var movies: [MovieViewModel] { get }

  func handleViewWillAppear()
  func handleSearchDidChange(_ search: String?)
  func handleDidSelectMovieAt(index: Int)
  func handleDidToggleFavorite(for movie: MovieViewModel)
  func handleRetryLoadingState()
}

final class SearchPresenter: SearchOutput {

  // MARK: - Properties

  weak var view: SearchInput!
  let router: SearchRouter
  var movies: [MovieViewModel] = []

  private let moviesService: MoviesService
  private let favoritesService: FavoritesService
  private let appConfigurations: AppConfigurations
  private let imageDownloaderProvider: any ImageDownloaderProvider

  private var movieViewModelsSource: [MovieViewModel] = []
  private var moviesSource: [Movie] = []
  private var searchText: String?

  // MARK: - Life cycle

  init(router: SearchRouter, dependencyContainer: DependencyContainer) {
    self.router = router
    self.moviesService = dependencyContainer.moviesService
    self.favoritesService = dependencyContainer.favoritesService
    self.appConfigurations = dependencyContainer.appConfigurations
    self.imageDownloaderProvider = dependencyContainer.imageDownloaderProvider
  }

  // MARK: - SearchOutput

  func handleViewWillAppear() {
    if moviesSource.isEmpty {
      loadMovies()
    } else {
      reloadFilteredMovies()
    }

    view.setTitle("All Movies")
  }

  func handleSearchDidChange(_ search: String?) {
    searchText = search
    reloadFilteredMovies()
  }

  func handleDidSelectMovieAt(index: Int) {
    let movieViewModel = movies[index]
    guard let movie = moviesSource.first(where: { $0.id == movieViewModel.id }) else { return }
    router.didSelectMovie(movie)
  }

  func handleDidToggleFavorite(for movie: MovieViewModel) {
    if movie.isFavorite {
      favoritesService.removeMovieWith(id: movie.id)
    } else {
      guard let movie = moviesSource.first(where: { $0.id == movie.id }) else { return }
      favoritesService.saveMovie(movie)
    }
    movie.isFavorite.toggle()
  }

  func handleRetryLoadingState() {
    loadMovies()
  }
}

// MARK: - Helpers

private extension SearchPresenter {

  func loadMovies() {
    view.setLoadingState(.loading)
    Task {
      let result = await moviesService.fetchAll()

      await handleMoviesResult(result)
    }
  }

  @MainActor
  func handleMoviesResult(_ result: Result<[Movie], Error>) {
    switch result {
    case .success(let movies):
      view.setLoadingState(.none)
      handleSuccess(movies)
    case .failure(let error):
      view.setLoadingState(.retry(error.localizedDescription))
    }
  }

  func handleSuccess(_ movies: [Movie]) {
    self.moviesSource = movies

    movieViewModelsSource = moviesSource.map {
      MovieViewModelBuilder(
        movie: $0,
        favoritesService: favoritesService,
        appConfigurations: appConfigurations,
        imageDownloaderProvider: imageDownloaderProvider
      ).build()
    }

    reloadFilteredMovies()
  }

  func reloadFilteredMovies() {
    defer {
      view.reloadData()
    }

    guard let searchText, !searchText.isEmpty else {
      movies = movieViewModelsSource
      return
    }

    movies = movieViewModelsSource.filter {
      $0.title.localizedCaseInsensitiveContains(searchText)
    }
  }
}
