//
//  HomePresenterTable.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import UIKit

enum HomeTableSection {
  case favorites(_ title: AttributedString)
  case stuffPicks(_ title: AttributedString, _ rows: Int)
}

extension HomeTableSection {

  static var favoritesTitle: AttributedString {
    attributedTitleWith(part1: "YOUR", part2: "FAVORITES")
  }

  static var stuffPicksTitle: AttributedString {
    attributedTitleWith(part1: "OUR", part2: "STAFF PICKS")
  }

  private static func attributedTitleWith(part1: String, part2: String) -> AttributedString {
    var attributes = AttributeContainer()
    attributes.foregroundColor = UIColor(named: "background")
    attributes.font = UIFont.systemFont(ofSize: 12)
    let part1Str = AttributedString(part1, attributes: attributes)

    attributes.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    let part2Str = AttributedString(part2, attributes: attributes)

    return part1Str + " " + part2Str
  }
}
