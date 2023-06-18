//
//  EventDetailViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import Foundation
import SwiftUI
import UIKit

class EventDetailViewModel: ObservableObject {
    let title: String
    @Published var image: UIImage // TODO: Subscribe this image to the one in the parent view model
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
        let noImage = UIImage.init(named: "NoImage")!
        if let photoData = event.photoData {
            self.image = UIImage.init(data: photoData) ?? noImage
        } else {
            self.image = noImage
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
    }
}

// TODO: Fill the below two classes for adding the event to calendar and reminders
// with the code to hold the data needed to add the event to cal or reminders. Then,
// write a method in each class that the view can call to do so
class EventCalendarViewModel {
    
}

class EventReminderViewModel {
}
