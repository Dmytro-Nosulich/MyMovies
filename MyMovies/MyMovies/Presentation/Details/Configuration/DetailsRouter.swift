//
//  DetailsRouter.swift
//  MyMovies
//
//  Created by Dmytro on 14.06.25.
//

import UIKit

protocol DetailsRouter {

  func didTapDismiss()
}

struct DefaultDetailsRouter: DetailsRouter {

  let rootController: UIViewController

  func didTapDismiss() {
    rootController.dismiss(animated: true)
  }
}
