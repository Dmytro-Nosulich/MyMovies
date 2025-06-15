//
//  MovieViewModel.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import UIKit

final class MovieViewModel {

  let id: Int
  var posterDownloader: ImageDownloader?
  var rating: Int = 0
  var releaseDate: String = ""
  var releaseYear: String = ""
  var duration: String = ""
  var title: String = ""
  var genres: [String] = []
  var overview: String = ""
  var keyFacts: FactContainer!
  var isFavorite: Bool = false

  init(id: Int) {
    self.id = id
  }
}

extension MovieViewModel {

  struct FactContainer {
    let budget: Fact
    let revenue: Fact
    let language: Fact
    let rating: Fact
  }

  struct Fact {
    let title: String
    let value: String
  }
}

struct MovieViewModelBuilder {

  let movie: Movie
  let favoritesService: FavoritesService
  let appConfigurations: AppConfigurations
  let imageDownloaderProvider: any ImageDownloaderProvider

  func build() -> MovieViewModel {
    let viewModel = MovieViewModel(id: movie.id)

    viewModel.rating = Int(movie.rating)
    viewModel.releaseDate = getReleaseDate()
    viewModel.releaseYear = getReleaseYear()
    viewModel.duration = getDuration()
    viewModel.title = movie.title
    viewModel.genres = movie.genres
    viewModel.overview = movie.overview
    viewModel.keyFacts = getKeyFacts()
    viewModel.isFavorite = isFavorite()
    if let posterUrl = URL(string: movie.posterUrl) {
      viewModel.posterDownloader = imageDownloaderProvider.imageDownloader(for: posterUrl,
                                                                           completion: nil)
    }

    return viewModel
  }
}

private extension MovieViewModelBuilder {

  func currencyFormatter(_ value: Int) -> String {
    let price = Decimal(value)
    return price.formatted(
      .currency(code: "USD")
      .presentation(.narrow)
      .precision(.fractionLength(0))
    )
  }

  private func getReleaseDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: movie.releaseDate)
  }

  private func getReleaseYear() -> String {
    let calendar = appConfigurations.calendar
    let components = calendar.dateComponents([.year], from: movie.releaseDate)
    if let year = components.year {
      return "\(year)"
    } else {
      return ""
    }
  }

  private func getDuration() -> String {
    let duration = Duration.seconds(movie.runtime * 60)
    return duration.formatted(.units(width: .narrow))
  }

  private func getKeyFacts() -> MovieViewModel.FactContainer {
    .init(budget: budgetFact(),
          revenue: revenueFact(),
          language: languageFact(),
          rating: ratingFact())
  }

  private func budgetFact() -> MovieViewModel.Fact {
    let value = currencyFormatter(movie.budget)
    return .init(title: "Budget",
                 value: value)
  }

  private func revenueFact() -> MovieViewModel.Fact {
    let value: String
    if let revenue = movie.revenue {
      value = currencyFormatter(revenue)
    } else {
      value = "N/A"
    }
    return .init(title: "Revenue",
                 value: value)
  }

  private func languageFact() -> MovieViewModel.Fact {
    let language = appConfigurations.locale.localizedString(forLanguageCode: movie.language)
    return .init(title: "Original Language",
                 value: language ?? "")
  }

  private func ratingFact() -> MovieViewModel.Fact {
    let rating = String(format: "%.2f", movie.rating)
    return .init(title: "Rating",
                 value: "\(rating) (\(movie.reviews))")
  }

  private func isFavorite() -> Bool {
    favoritesService.savedMovies.contains(movie)
  }
}
