//
//  HomeRouter.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import UIKit

protocol HomeRouter {

  func didSelectMovie(_ movie: Movie)
  func didSelectSearchMovies()
}

struct DefaultHomeRouter: HomeRouter {

  let navigationController: UINavigationController

  func didSelectMovie(_ movie: Movie) {
    let detailsView = Details.build(with: movie, on: navigationController)
    detailsView.modalPresentationStyle = .fullScreen
    navigationController.present(detailsView, animated: true)
  }

  func didSelectSearchMovies() {
    let searchView = Search.build(with: navigationController)
    navigationController.pushViewController(searchView, animated: true)
  }
}
