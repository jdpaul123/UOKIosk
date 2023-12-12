//
//  CreateReminderError.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 12/8/23.
//

import Foundation

enum CreateReminderError: Error, LocalizedError {
    case noDefaultCalendarForNewReminders

    var errorDescription: String? {
        switch self {
        case .noDefaultCalendarForNewReminders:
            return NSLocalizedString("There is no default calendar for new reminders", comment: "")
        }
    }
}
