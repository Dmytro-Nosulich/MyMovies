//
//  Search.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

struct Search {

  static func build(with navigationController: UINavigationController) -> UIViewController {
    let router = DefaultSearchRouter(rootNavigationController: navigationController)
    let presenter = SearchPresenter(router: router, dependencyContainer: .init())
    let view = SearchViewController.fromXib()
    view.presenter = presenter
//    view.title = "All Movies"
    return view
  }
}
