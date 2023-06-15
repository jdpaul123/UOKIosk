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
    // MARK: Initialization
    convenience init(eventData: EventDto, context: NSManagedObjectContext) {
        self.init(context: context)
        
        func getUrl(urlString: String?) -> URL? {
            guard let urlString = urlString else {
                return nil
            }
            return URL(string: urlString)
        }
        
        func getPhotoData(urlString: String?) -> Data? {
            guard let urlString = urlString else {
                return nil
            }
            guard let photoURL = URL(string: urlString) else {
                return nil
            }
            guard let data = try? Data(contentsOf: photoURL) else {
                return nil
            }
            return data
        }
        
        func getEventInstanceDateData(dateData: EventInstanceDto) -> (Bool, Date, Date?) {
            let startStr: String = dateData.start
            let endStr: String? = dateData.end
            
            // Format the start and end dates if they exist
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
            let start: Date
            let end: Date?
            
            start = {
                guard let date = dateFormatter.date(from: startStr) else {
                    fatalError("Start date could not be determined form the provided date string")
                }
                return date
            }()
           
            if endStr != nil {
                end = dateFormatter.date(from: endStr!)
            } else {
                end = nil
            }
            
            let allDay = dateData.allDay
            return (allDay, start, end)
        }
        
        self.id = Int64(exactly: eventData.id)!
        self.title = eventData.title
        self.eventDescription = eventData.descriptionText
        
        self.locationName = eventData.locationName
        self.roomNumber = eventData.roomNumber
        self.address = eventData.address
        
        self.status = eventData.status ?? "live"
        self.experience = eventData.experience ?? "assumed inperson"

        self.eventUrl = getUrl(urlString: eventData.localistUrl)
        self.streamUrl = getUrl(urlString: eventData.streamUrl)
        self.ticketUrl = getUrl(urlString: eventData.ticketUrl)
        self.venueUrl = getUrl(urlString: eventData.venueUrl)
        self.calendarUrl = getUrl(urlString: eventData.icsUrl)

        self.photoData = getPhotoData(urlString: eventData.photoUrl)

        self.ticketCost = eventData.ticketCost
        
        guard let eventInstances = eventData.eventInstances else {
            fatalError("There are no event instances to access")
        }
        let dateData = eventInstances[0].eventInstance
        let dateValues = getEventInstanceDateData(dateData: dateData)
        self.allDay = dateValues.0
        self.start  = dateValues.1
        self.end = dateValues.2

        self.departmentFilters = []
        self.eventTypeFilters = []
        self.targetAudienceFilters = []
        // TODO: Calling addTo_Filters() method is causing problems having it in the init. Must change app so that these filters are set after the event is instantiated
//        if let eventFilters = eventData.filters.eventTypes {
//            for eventFilter in eventFilters {
//                addToEventTypeFilters(EventFilter(id: eventFilter.id, name: eventFilter.name, context: context))
//            }
//        }
//        if let dtoDepartmentFilters = eventData.filters.departments {
//            for eventFilter in dtoDepartmentFilters {
//                addToDepartmentFilters(EventFilter(id: eventFilter.id, name: eventFilter.name, context: context))
//            }
//        }
//        if let dtoTargetAudienceFilters = eventData.filters.eventTargetAudience {
//            for eventFilter in dtoTargetAudienceFilters {
//                addToTargetAudienceFilters(EventFilter(id: eventFilter.id, name: eventFilter.name, context: context))
//            }
//        }

        guard let geo = eventData.geo, let latitude = geo.latitude, let longitude = geo.longitude, let city = geo.city, let country = geo.country,
              let _ = geo.state, let street = geo.street, let zip = geo.zip else {
            self.eventLocation = nil
            return
        }
        self.eventLocation = EventLocation(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0,
                                           street: street, city: city, country: country,
                                           zip: Int(zip) ?? 0, context: context)
    }
}

// MARK: - Initialization for Testing
extension Event {
    convenience init(id: Int, title: String, eventDescription: String, locationName: String?, roomNumber: String?,
         address: String?, status: String, experience: String, eventUrl: URL?, streamUrl: URL?,
         ticketUrl: URL?, venueUrl: URL?, calendarUrl: URL?, photoData: Data?, ticketCost: String?,
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
        self.ticketCost = ticketCost
        self.start = start
        self.end = end
        self.allDay = allDay
        self.eventLocation = eventLocation
        // Create the department filters array
        self.departmentFilters = []
        for filter in departmentFilters {
            self.departmentFilters?.adding(filter)
        }
        // Create the audience filters array
        self.targetAudienceFilters = []
        for filter in targetAudienceFilters {
            self.targetAudienceFilters?.adding(filter)
        }
        // Create the event type filters array
        self.eventTypeFilters = []
        for filter in eventTypeFilters {
            self.eventTypeFilters?.adding(filter)
        }
    }
}
