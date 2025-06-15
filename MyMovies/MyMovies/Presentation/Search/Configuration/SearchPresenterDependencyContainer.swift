//
//  SearchPresenterDependencyContainer.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import Foundation

extension SearchPresenter {

  struct DependencyContainer {
    let moviesService: MoviesService
    let favoritesService: FavoritesService
    let appConfigurations: AppConfigurations
    let imageDownloaderProvider: any ImageDownloaderProvider

    init(
      moviesService: MoviesService = MoviesServiceAssembly.shared,
      favoritesService: FavoritesService = FavoritesServiceAssembly.shared,
      appConfigurations: AppConfigurations = AppConfigurationAssembly.shared,
      imageDownloaderProvider: any ImageDownloaderProvider = ImageDownloaderProviderAssembly.shared
    ) {
      self.moviesService = moviesService
      self.favoritesService = favoritesService
      self.appConfigurations = appConfigurations
      self.imageDownloaderProvider = imageDownloaderProvider
    }
  }
}
