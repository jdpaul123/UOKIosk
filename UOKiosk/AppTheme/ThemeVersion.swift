//
//  ThemeVersion.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import Foundation

// Conform to Int to easily store the theme version in User Defaults
enum ThemeVersion: Int {
    case green = 0
    case yellow = 1
    case greenYellow = 2
    case no = 3

    static func getTheme(theme: Int) throws -> Theme {
        guard let theme = ThemeVersion(rawValue: theme)?.theme else {
            throw ThemeError.themeVersionIndexOutOfRange
        }
        return theme
    }

    var theme: Theme {
        switch self {
        case .green:
            return GreenTheme()
        case .yellow:
            return YellowTheme()
        case .greenYellow:
            return GreenTheme()
        case .no:
            return NoTheme()
        }
    }

    enum ThemeError: Error {
        case themeVersionIndexOutOfRange
    }
}
