//
//  Event+CoreDataClass.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData

public class Event: NSManagedObject {
    // MARK: Transient Properties / In-Memory Properties
    @Published public var imPhotoData: Data? {
        willSet {
            objectWillChange.send()
        }
    }

    // MARK: Initialization
    convenience init(id: Int, title: String, eventDescription: String, locationName: String?, roomNumber: String?,
                     address: String?, status: String, experience: String, eventUrl: URL?, streamUrl: URL?,
                     ticketUrl: URL?, venueUrl: URL?, calendarUrl: URL?, photoData: Data?, photoUrl: URL?, ticketCost: String?,
                     start: Date, end: Date?, allDay: Bool, eventLocation: EventLocation?, departmentFilters: [EventFilter],
                     targetAudienceFilters: [EventFilter], eventTypeFilters: [EventFilter], context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = Int64(exactly: id)!
        self.title = title
        self.eventDescription = eventDescription
        self.locationName = locationName
        self.roomNumber = roomNumber
        self.address = address
        self.status = status
        self.experience = experience
        self.eventUrl = eventUrl
        self.streamUrl = streamUrl
        self.ticketUrl = ticketUrl
        self.venueUrl = venueUrl
        self.calendarUrl = calendarUrl
        self.photoData = photoData
        self.photoUrl = photoUrl
        self.ticketCost = ticketCost
        self.start = start
        self.end = end
        self.allDay = allDay
    }
}
