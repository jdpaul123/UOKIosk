//
//  EventDetailViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import Foundation
import UIKit
import Combine
import EventKit

class EventDetailViewModel: ObservableObject {
    @Published var imageData: Data
    var cancellables = Set<AnyCancellable>()

    let event: IMEvent
    let title: String
    let location: String
    let hasLocation: Bool
    let roomNumber: String
    let dateRange: String // Ex. Thursday, August 18, 2022 or Thursday, August 18, 2022 - Thursday, September 25, 2022
    let timeRange: String // Ex. All Day or 8:00 AM - 5:30 PM
    let eventDescription: String
    let website: URL?

    var hasAbilityToAddReminder: Bool {
        ReminderService.shared.isAvailable
    }

    init(event: IMEvent) {
        self.event = event
        self.title = event.title
        let noImageData = UIImage.init(named: "NoImage")!.pngData()!
        if let photoData = event.photoData {
            self.imageData = photoData
        } else {
            self.imageData = noImageData
        }

        self.location = event.locationName ?? ""
        self.hasLocation = event.locationName == "" ? false : true
        self.roomNumber = event.roomNumber ?? ""

        self.dateRange = {
            let start = event.start
            let startDateString = start.formatted(date: .complete, time: .omitted)
            let endDateString = event.end?.formatted(date: .complete, time: .omitted) ?? ""
            
            if startDateString == endDateString || endDateString == "" {
                return startDateString
            }
            
            return "\(startDateString) - \(endDateString)"
        }()
        
        self.timeRange = {
            let start = event.start
            let startTimeString = start.formatted(date: .omitted, time: .shortened)
            let endTimeString = event.end?.formatted(date: .omitted, time: .shortened) ?? ""
            
            if event.allDay {
                return "All Day"
            }
            else if startTimeString == endTimeString || endTimeString == "" {
                return startTimeString
            }
            
            return "\(startTimeString) - \(endTimeString)"
        }()
        
        self.eventDescription = event.eventDescription
        self.website = event.eventUrl

        subscribeImageDataToEvent(event: event)
    }

    func subscribeImageDataToEvent(event: IMEvent) {
        event.$photoData
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("!!! Failed to get image data for Event Cell for event, \(event.title), with Error: \(error.localizedDescription)")
                }
                self.cancellables.removeAll()
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                if let imageData = data {
                    self.imageData = imageData
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Reminders
    func tryAddReminder() -> Bool {
        if ReminderService.shared.isAvailable {
            do {
                try ReminderService.shared.addReminder(title: title, eventDescription: eventDescription, eventStart: event.start)
            } catch {
                print("Adding reminder failed with error: \(error.localizedDescription)")
                return false
            }
            print("SUCCEEDED ADDING REMINDER")
            return true
        }
        return false
    }

    func prepareReminderStore() {
        Task {
            do {
                try await ReminderService.shared.requestAccess()
            } catch PermissionError.accessDenied, PermissionError.accessRestricted {
                print("prepareReminderStore access denied and access restricted")
            } catch {
                print("prepareReminderStore failed")
            }

            do {
                try await ReminderService.shared.requestContactAccess()
            } catch PermissionError.accessDenied, PermissionError.accessRestricted {
                print("prepareReminderStore access denied and access restricted")
            } catch {
                print("prepareReminderStore failed")
            }
        }
    }
}
