//
//  ThemeDefinitions.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import SwiftUI

struct GreenTheme: Theme {
    private(set) var primaryUIColor = UIColor(resource: .primaryGreen)
    private(set) var secondaryUIColor = UIColor(resource: .secondaryGreen)
    private(set) var primaryColor = Color(uiColor: UIColor(resource: .primaryGreen))
    private(set) var secondaryColor = Color(uiColor: UIColor(resource: .secondaryGreen))
}

struct YellowTheme: Theme {
    private(set) var primaryUIColor = UIColor(resource: .primaryYellow)
    private(set) var secondaryUIColor = UIColor(resource: .secondaryYellow)
    private(set) var primaryColor = Color(uiColor: UIColor(resource: .primaryYellow))
    private(set) var secondaryColor = Color(uiColor: UIColor(resource: .secondaryYellow))
}

struct GreenYellowTheme: Theme {
    private(set) var primaryUIColor = UIColor(resource: .primaryGreen)
    private(set) var secondaryUIColor = UIColor(resource: .secondaryYellow)
    private(set) var primaryColor = Color(uiColor: UIColor(resource: .primaryGreen))
    private(set) var secondaryColor = Color(uiColor: UIColor(resource: .primaryYellow))
}

struct NoTheme: Theme {
    private(set) var primaryUIColor: UIColor = .systemBackground
    private(set) var secondaryUIColor: UIColor = .systemBackground
    private(set) var primaryColor = Color(uiColor: .systemBackground)
    private(set) var secondaryColor = Color(uiColor: .systemBackground)
}
