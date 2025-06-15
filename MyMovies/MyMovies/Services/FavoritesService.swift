//
//  FavoritesService.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import Foundation

protocol FavoritesService {

  var savedMovies: [Movie] { get }
  func saveMovie(_ movie: Movie)
  func removeMovieWith(id: Int)
}

final class DefaultFavoritesService: FavoritesService {

  // MARK: - Properties

  private(set) var savedMovies: [Movie] = []

  private let defaultsService: DefaultsService

  // MARK: - Life cycle

  init(defaultsService: DefaultsService) {
    self.defaultsService = defaultsService

    savedMovies = defaultsService.retrieveItem(for: .favoriteMoviesList) ?? []
  }

  // MARK: - FavoritesService

  func saveMovie(_ movie: Movie) {
    guard !savedMovies.contains(movie) else { return }
    savedMovies.append(movie)
    defaultsService.setItem(savedMovies, for: .favoriteMoviesList)
  }

  func removeMovieWith(id: Int) {
    guard let index = savedMovies.firstIndex(where: { $0.id == id }) else { return }
    savedMovies.remove(at: index)
    defaultsService.setItem(savedMovies, for: .favoriteMoviesList)
  }
}

// MARK: - Assembly

struct FavoritesServiceAssembly {

  static let shared: FavoritesService = DefaultFavoritesService(
    defaultsService: DefaultsServiceAssembly.standard
  )
}
