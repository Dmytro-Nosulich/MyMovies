//
//  NetworkConfiguration.swift
//  MyMovies
//
//  Created by Dmytro Nosulich on 12.06.25.
//

import Foundation

struct NetworkConfiguration {
  let baseUrl: URL
  let headers: [String: String]
  let cachePolicy: URLRequest.CachePolicy
  let timeoutInterval: TimeInterval
}

extension NetworkConfiguration {
  static let `default`: NetworkConfiguration = .init(
    baseUrl: URL(string: "https://apps.agentur-loop.com")!,
    headers: ["Content-type": "application/json"],
    cachePolicy: .useProtocolCachePolicy,
    timeoutInterval: 10
  )
}
