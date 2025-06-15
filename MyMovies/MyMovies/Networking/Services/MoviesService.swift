//
//  UserService.swift
//  MyMovies
//
//  Created by Dmytro Nosulich on 12.06.25.
//

import Foundation

protocol MoviesService {

  var stuffPicks: [Movie] { get }
  var allMovies: [Movie] { get }

  func fetchStuffPicks() async -> Result<[Movie], Error>
  func fetchAll() async -> Result<[Movie], Error>
}

final class DefaultMoviesService: MoviesService {

  // MARK: - Properties

  var stuffPicks: [Movie] = []
  var allMovies: [Movie] = []

  private let networkManager: NetworkManager

  // MARK: - Life cycle

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  // MARK: - Public methods

  func fetchStuffPicks() async -> Result<[Movie], Error> {
    let request = APICallRequest(method: .get, path: "challenge/staff_picks.json")
    let result: Result<[Movie], Error>
    do {
      let movies: [Movie] = try await networkManager.sendRequest(request)
      self.stuffPicks = movies
      result = .success(movies)
    } catch {
      result = .failure(error)
    }

    return result
  }

  func fetchAll() async -> Result<[Movie], Error> {
    let request = APICallRequest(method: .get, path: "challenge/movies.json")
    let result: Result<[Movie], Error>
    do {
      let movies: [Movie] = try await networkManager.sendRequest(request)
      self.allMovies = movies
      result = .success(movies)
    } catch {
      result = .failure(error)
    }

    return result
  }
}

// MARK: - Assembly

final class MoviesServiceAssembly {
  static let shared: MoviesService = DefaultMoviesService(
    networkManager: NetworkManagerAssembly.shared
  )
}
