//
//  Home.swift
//  MyMovies
//
//  Created by Dmytro on 12.06.25.
//

import UIKit

struct Home {

  static func build() -> UIViewController {
    let navigationController = UINavigationController()
    navigationController.navigationBar.tintColor = .black
    let router = DefaultHomeRouter(navigationController: navigationController)
    let presenter = HomePresenter(router: router, dependencyContainer: .init())
    let view = HomeViewController.fromXib()
    view.presenter = presenter
    view.title = ""
    navigationController.viewControllers = [view]

    return navigationController
  }
}
