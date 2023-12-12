//
//  PermissionError.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 12/8/23.
//

import Foundation

enum PermissionError: LocalizedError {
    case accessDenied
    case accessRestricted
    case unknown

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString(
                "The app doesn't have permission to read reminders.",
                comment: "access denied error description")
        case .accessRestricted:
            return NSLocalizedString(
                "This device doesn't allow access to reminders.",
                comment: "access restricted error description")
        case .unknown:
            return NSLocalizedString("An unknown error occurred.", comment: "unknown error description")
        }
    }
}
