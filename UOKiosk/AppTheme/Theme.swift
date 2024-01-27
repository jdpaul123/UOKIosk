//
//  Theme.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 1/15/24.
//

import SwiftUI

protocol Theme {
    var primaryUIColor: UIColor { get }
    var secondaryUIColor: UIColor { get }
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
}
