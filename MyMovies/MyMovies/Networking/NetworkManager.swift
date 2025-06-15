//
//  NetworkManager.swift
//  MyMovies
//
//  Created by Dmytro Nosulich on 12.06.25.
//

import Foundation

protocol NetworkManager {

  func sendRequest<Response: Decodable>(_ request: Request) async throws -> Response
  func download(for request: Request) async throws -> URL
}

final class DefaultNetworkManager: NetworkManager {

  // MARK: - Properties

  private let session: URLSession = .shared

  // MARK: - Public methods

  func sendRequest<Response: Decodable>(_ request: Request) async throws -> Response {
    let urlRequest = request.asURLRequest()

    let (data, _) = try await session.data(for: urlRequest)
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    let result = try decoder.decode(Response.self, from: data)
    return result
  }

  func download(for request: Request) async throws -> URL {
    let urlRequest = request.asURLRequest()

    let (data, _) = try await session.download(for: urlRequest)
    return data
  }
}

// MARK: - Assembly

final class NetworkManagerAssembly {

  static let shared: NetworkManager = DefaultNetworkManager()
}
