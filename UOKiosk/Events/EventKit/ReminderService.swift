//
//  ReminderService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/19/23.
//
// Help from: https://developer.apple.com/tutorials/app-dev-training/loading-reminders

// FIXME: For iOS 17 more permissions will have to be added to info.plist. Refer to this link: https://developer.apple.com/documentation/eventkit/accessing_the_event_store
/*
 Protect user privacy with information property list keys
 An iOS app must include in its Info.plist file the usage description keys for the types of data it needs to access. On iOS 17 and later, to access a person’s calendar events or reminders, you need to include descriptions for:

 NSCalendarsWriteOnlyAccessUsageDescription or NSCalendarsFullAccessUsageDescription, depending on the level of access to events your app needs. Don’t request full access if your app’s features only need write-only access.
 NSRemindersFullAccessUsageDescription, if your app needs access to reminders.
 */

import EventKit
import Contacts
import Foundation

final class ReminderService {
    static let shared = ReminderService()

    private let ekStore = EKEventStore()
    private let cnStore = CNContactStore()

    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }

    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .restricted:
            throw PermissionError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw PermissionError.accessDenied
            }
        case .denied:
            throw PermissionError.accessDenied
        @unknown default:
            throw PermissionError.unknown
        }
    }

    func requestContactAccess() async throws {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized:
            return
        case .restricted:
            throw PermissionError.accessRestricted
        case .notDetermined:
            let accessGranted = try await cnStore.requestAccess(for: .contacts)
            guard accessGranted else {
                throw PermissionError.accessDenied
            }
        case .denied:
            throw PermissionError.accessDenied
        @unknown default:
            throw PermissionError.unknown
        }
    }

    func addReminder(title: String, eventDescription: String, eventStart: Date) throws {
        let reminder = EKReminder(eventStore: ekStore)
        reminder.title = title
        reminder.notes = eventDescription
        guard let calendar = ekStore.defaultCalendarForNewReminders() else {
            throw CreateReminderError.noDefaultCalendarForNewReminders
        }
        reminder.calendar = calendar
        reminder.priority = Int(EKReminderPriority.high.rawValue)
        reminder.isCompleted = false
        reminder.addAlarm(EKAlarm(absoluteDate: eventStart))

        do {
            try ekStore.save(reminder, commit: true)
        } catch {
            throw error
        }
        print("SUCCESS ADDING EVENT TO REMINDERS")
    }
}

enum CreateReminderError: Error, LocalizedError {
    case noDefaultCalendarForNewReminders

    var errorDescription: String? {
        switch self {
        case .noDefaultCalendarForNewReminders:
            return NSLocalizedString("There is no default calendar for new reminders", comment: "")
        }
    }
}

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
