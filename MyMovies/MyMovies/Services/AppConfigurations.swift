//
//  AppConfigurations.swift
//  MyMovies
//
//  Created by Dmytro on 13.06.25.
//

import Foundation

class AppConfigurations {

  let locale: Locale
  let calendar: Calendar

  init(locale: Locale, calendar: Calendar) {
    self.locale = locale
    self.calendar = calendar
  }
}

struct AppConfigurationAssembly {
  static let shared =  AppConfigurations(
    locale: .current,
    calendar: .current
  )
}
