//
//  ReminderService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/19/23.
//
/*
 https://developer.apple.com/tutorials/app-dev-training/loading-reminders
 Protect user privacy with information property list keys
 An iOS app must include in its Info.plist file the usage description keys for the types of data it needs to access.
 On iOS 17 and later, to access a person’s calendar events or reminders, you need to include descriptions for:
 - NSCalendarsWriteOnlyAccessUsageDescription
 - NSRemindersFullAccessUsageDescription
 */

import EventKit
import Contacts
import Foundation

protocol ReminderServiceProtocol {
    var isAvailable: Bool { get }
    func requestAccess() async throws
    func requestContactAccess() async throws
    func addReminder(title: String, eventDescription: String, eventStart: Date) throws
}

final class ReminderService: ReminderServiceProtocol {
    static let shared = ReminderService()

    private let ekStore = EKEventStore()
    private let cnStore = CNContactStore()

    var isAvailable: Bool {
        let authStatus = EKEventStore.authorizationStatus(for: .reminder)
        if #available(iOS 17.0, *) {
            return authStatus == .writeOnly || authStatus == .fullAccess
        } else {
            return authStatus == .authorized
        }
    }

    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .restricted:
            throw PermissionError.accessRestricted
        case .notDetermined:
            let accessGranted: Bool
            if #available(iOS 17.0, *) {
                accessGranted = try await ekStore.requestFullAccessToReminders()
            } else {
                accessGranted = try await ekStore.requestAccess(to: .reminder)
            }
            guard accessGranted else {
                throw PermissionError.accessDenied
            }
        case .fullAccess, .writeOnly:
            return
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
