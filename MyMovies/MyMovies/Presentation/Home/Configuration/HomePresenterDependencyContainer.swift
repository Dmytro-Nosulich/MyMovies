//
//  HomePresenterDependencyContainer.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import Foundation

extension HomePresenter {

  struct DependencyContainer {
    let userService: UserService
    let moviesService: MoviesService
    let favoritesService: FavoritesService
    let appConfigurations: AppConfigurations
    let imageDownloaderProvider: any ImageDownloaderProvider

    init(
      userService: UserService = UserServiceAssembly.shared,
      moviesService: MoviesService = MoviesServiceAssembly.shared,
      favoritesService: FavoritesService = FavoritesServiceAssembly.shared,
      appConfigurations: AppConfigurations = AppConfigurationAssembly.shared,
      imageDownloaderProvider: any ImageDownloaderProvider = ImageDownloaderProviderAssembly.shared
    ) {
      self.userService = userService
      self.moviesService = moviesService
      self.favoritesService = favoritesService
      self.appConfigurations = appConfigurations
      self.imageDownloaderProvider = imageDownloaderProvider
    }
  }
}
