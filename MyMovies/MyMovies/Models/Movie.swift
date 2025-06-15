//
//  Movie.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import Foundation

final class Movie: Codable, Equatable {

  var id: Int
  var rating: Float
  var revenue: Int?
  var releaseDate: Date
  var posterUrl: String
  var runtime: Int
  var title: String
  var overview: String
  var reviews: Int
  var budget: Int
  var language: String
  var genres: [String]

  static func == (lhs: Movie, rhs: Movie) -> Bool {
    lhs.id == rhs.id
  }
}
