//
//  Sequence+Utils.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import Foundation

extension Optional where Wrapped: Collection {

  var isNilOrEmpty: Bool {
    guard let sequence = self else {
      return true
    }
    return sequence.isEmpty
  }
}
