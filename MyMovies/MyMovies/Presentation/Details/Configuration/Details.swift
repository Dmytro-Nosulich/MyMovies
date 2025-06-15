//
//  Details.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

struct Details {

  static func build(with movie: Movie, on viewController: UIViewController) -> UIViewController {
    let router = DefaultDetailsRouter(rootController: viewController)
    let presenter = DetailsPresenter(movie: movie, router: router, dependencyContainer: .init())
    let view = DetailsViewController.fromXib()
    view.presenter = presenter
    return view
  }
}
