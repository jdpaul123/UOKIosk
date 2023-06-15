//
//  WhatIsOpenViewType.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/12/23.
//

import Foundation

enum WhatIsOpenViewType: String {
    case dining, stores, facilities

    var showHoursButton: Bool {
        switch self {
        case .dining:
            return true
        default:
            return false
        }
    }
}
