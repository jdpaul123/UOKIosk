//
//  EventDetailViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import Foundation
import UIKit
import Combine

class EventDetailViewModel: ObservableObject {
    @Published var imageData: Data
    var cancellables = Set<AnyCancellable>()

    let title: String
    let location: String
    let hasLocation: Bool
    let roomNumber: String
    let dateRange: String // Ex. Thursday, August 18, 2022 or Thursday, August 18, 2022 - Thursday, September 25, 2022
    let timeRange: String // Ex. All Day or 8:00 AM - 5:30 PM
    let eventDescription: String
    let website: URL?
    
    let calendarData: EventCalendarViewModel
    let reminderData: EventReminderViewModel

    init(event: IMEvent) {
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
        
        self.calendarData = EventCalendarViewModel()
        self.reminderData = EventReminderViewModel()

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
}

// TODO: Fill the below two classes for adding the event to calendar and reminders
// with the code to hold the data needed to add the event to cal or reminders. Then,
// write a method in each class that the view can call to do so
class EventCalendarViewModel {
    
}

class EventReminderViewModel {
}
