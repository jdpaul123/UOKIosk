//
//  Color+ApplicationDefaults.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/26/22.
//

import Foundation
import SwiftUI

extension Color {
    // Should be used as the furthest back background color
    static let UOKioskBackgroundColor = Color.init(uiColor: .systemGroupedBackground)
    // Should be used for background values on elements with text or other media
    static let UOKioskContentBackgroundColor = Color.init(uiColor: .secondarySystemGroupedBackground)
}
