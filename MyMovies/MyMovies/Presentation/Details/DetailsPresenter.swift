//
//  DetailsPresenter.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import Foundation

protocol DetailsInput: AnyObject {

  func configureView()
  func updateFavoriteButton()
}

protocol DetailsOutput: AnyObject {

  var view: DetailsInput! { get set }
  var movieViewModel: MovieViewModel { get }

  func handleViewDidLoad()
  func handleDidTapFavorite()
  func handleDidTapClose()
}

final class DetailsPresenter: DetailsOutput {

  weak var view: DetailsInput!
  let movieViewModel: MovieViewModel

  private let movie: Movie
  private let router: DetailsRouter
  private let favoritesService: FavoritesService

  init(movie: Movie, router: DetailsRouter, dependencyContainer: DependencyContainer) {
    self.movie = movie
    self.router = router
    self.favoritesService = dependencyContainer.favoritesService

    self.movieViewModel = MovieViewModelBuilder(
      movie: movie,
      favoritesService: favoritesService,
      appConfigurations: dependencyContainer.appConfigurations,
      imageDownloaderProvider: dependencyContainer.imageDownloaderProvider
    ).build()
  }

  // MARK: - DetailsOutput

  func handleViewDidLoad() {
    view.configureView()
  }

  func handleDidTapFavorite() {
    movieViewModel.isFavorite.toggle()

    if movieViewModel.isFavorite {
      favoritesService.saveMovie(movie)
    } else {
      favoritesService.removeMovieWith(id: movie.id)
    }

    view.updateFavoriteButton()
  }

  func handleDidTapClose() {
    router.didTapDismiss()
  }
}
