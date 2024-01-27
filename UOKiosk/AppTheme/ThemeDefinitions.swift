//
//  ThemeDefinitions.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import UIKit

struct GreenTheme: Theme {
    private(set) var primaryColor = UIColor(resource: .primaryGreen)
    private(set) var secondaryColor = UIColor(resource: .secondaryGreen)
}

struct YellowTheme: Theme {
    private(set) var primaryColor = UIColor(resource: .primaryYellow)
    private(set) var secondaryColor = UIColor(resource: .secondaryYellow)
}

struct GreenYellowTheme: Theme {
    private(set) var primaryColor = UIColor(resource: .primaryGreen)
    private(set) var secondaryColor = UIColor(resource: .secondaryYellow)
}

struct NoTheme: Theme {
    private(set) var primaryColor: UIColor = .systemBackground
    private(set) var secondaryColor: UIColor = .systemBackground
}
