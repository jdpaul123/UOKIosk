//
//  EKEventEditViewController+RequestAccess.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 12/6/23.
//

import Foundation
import EventKitUI

// This entension makes it so that EKEventEditViewController requests permission to write events to Calendar
extension EKEventEditViewController {
    open override func viewDidAppear(_ animated: Bool) {
        Task {
            do {
                let success = try await requestAccess()
                if success {
                    print("SUCCESS REQUESTING ACCESS TO ADD AN EVENT")
                } else {
                    print("FAILED TO GET ACCESS TO ADD AN EVENT WITH NO ERROR")
                }
            } catch {
                // TODO: Log the error
            }
        }
        super.viewDidAppear(animated)
    }

    @discardableResult
    func requestAccess(eventStoreClass: EKEventStore.Type = EKEventStore.self) async throws -> Bool {
        let status = eventStoreClass.authorizationStatus(for: .event)
        switch status {
        case .notDetermined, .denied:
            if #available(iOS 17.0, *) {
                // TODO: Is there a bug in .requestWriteOnlyAccessToEvents? When I use it and deny access in iOS 17, I am still able to add events to the calendar
                do {
                    let result = try await eventStore.requestWriteOnlyAccessToEvents()
                    return result
                } catch {
                    throw error
                }
            } else {
                do {
                    let result = try await eventStore.requestAccess(to: .event)
                    return result
                } catch {
                    throw error
                }
            }
        case .fullAccess, .authorized, .writeOnly:
            return true
        case .restricted:
            throw PermissionError.accessRestricted
        @unknown default:
            throw PermissionError.unknown
        }
    }
}
