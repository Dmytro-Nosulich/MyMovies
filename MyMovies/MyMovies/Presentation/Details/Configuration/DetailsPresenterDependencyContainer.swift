//
//  DetailsPresenterDependencyContainer.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import Foundation

extension DetailsPresenter {

  struct DependencyContainer {

    let favoritesService: FavoritesService
    let appConfigurations: AppConfigurations
    let imageDownloaderProvider: any ImageDownloaderProvider

    init(
      favoritesService: FavoritesService = FavoritesServiceAssembly.shared,
      appConfigurations: AppConfigurations = AppConfigurationAssembly.shared,
      imageDownloaderProvider: any ImageDownloaderProvider = ImageDownloaderProviderAssembly.shared
    ) {
      self.favoritesService = favoritesService
      self.appConfigurations = appConfigurations
      self.imageDownloaderProvider = imageDownloaderProvider
    }
  }
}
