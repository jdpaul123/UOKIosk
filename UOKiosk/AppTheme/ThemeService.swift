//
//  ThemeService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import SwiftUI

class ThemeService: ObservableObject {
    @AppStorage("sleectedTheme") private var selectedThemeUD = 0 {
        didSet {
            updateTheme()
        }
    }

    init() {
        updateTheme()
    }

    @Published var selectedTheme: Theme = NoTheme()

    func updateTheme() {
        // This would be a great place to use a macro to verify that the selectedThemeUD does not contain an index out of the range of possible themes
        if let updatedTheme = try? ThemeVersion.getTheme(theme: selectedThemeUD) {
            selectedTheme = updatedTheme
        }
    }
}
