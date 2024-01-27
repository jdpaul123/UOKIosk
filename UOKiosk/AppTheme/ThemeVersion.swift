//
//  ThemeVersion.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import Foundation

enum ThemeVersion: Int {
    case green = 0
    case yellow = 1
    case greenYellow = 2
    case no = 3

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
}
