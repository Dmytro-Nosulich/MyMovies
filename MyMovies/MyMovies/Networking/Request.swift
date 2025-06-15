//
//  Request.swift
//  MyMovies
//
//  Created by Dmytro Nosulich on 12.06.25.
//

import Foundation

protocol Request {
  func asURLRequest() -> URLRequest
}

struct APICallRequest: Request {
  let method: HTTPMethod
  let path: String
  var configuration: NetworkConfiguration = .default

  func asURLRequest() -> URLRequest {
    let url = configuration.baseUrl.appending(path: path)

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.toString()
    urlRequest.allHTTPHeaderFields = configuration.headers
    urlRequest.cachePolicy = configuration.cachePolicy
    urlRequest.timeoutInterval = configuration.timeoutInterval
    return urlRequest
  }
}

struct DownloadRequest: Request {

  let url: URL
  var configuration: NetworkConfiguration = .default

  func asURLRequest() -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = HTTPMethod.get.toString()
    urlRequest.cachePolicy = .returnCacheDataElseLoad
    urlRequest.timeoutInterval = configuration.timeoutInterval
    return urlRequest
  }
}

enum HTTPMethod: String {
  case get
  case post
  case put
  case delete

  func toString() -> String {
    return rawValue.uppercased()
  }
}
