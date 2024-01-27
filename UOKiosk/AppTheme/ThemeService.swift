//
//  ThemeService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import Foundation

enum ThemeService {
    static let themes: [Theme] = [GreenTheme(), YellowTheme(), GreenYellowTheme(), NoTheme()]

    static func getTheme(theme: ThemeVersion) -> Theme {
        themes[theme.rawValue]
    }
}
