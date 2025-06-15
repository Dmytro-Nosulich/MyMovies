//
//  SearchRouter.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

protocol SearchRouter {

  func didSelectMovie(_ movie: Movie)
}

struct DefaultSearchRouter: SearchRouter {

  let rootNavigationController: UINavigationController

  func didSelectMovie(_ movie: Movie) {
    let detailsView = Details.build(with: movie, on: rootNavigationController)
    detailsView.modalPresentationStyle = .fullScreen
    rootNavigationController.present(detailsView, animated: true)
  }
}
