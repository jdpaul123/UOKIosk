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
        
        if eventData.geo == nil || eventData.geo!.latitude == nil || eventData.geo!.longitude == nil ||
            eventData.geo!.city == nil || eventData.geo!.country == nil || eventData.geo!.state == nil ||
            eventData.geo!.street == nil || eventData.geo!.zip == nil ||
            Double(eventData.geo!.latitude!) == nil || Double(eventData.geo!.longitude!) == nil ||
            Int(eventData.geo!.zip!) == nil
        {
            self.eventLocation = nil
        }
        else {
            let geo = eventData.geo!
            self.eventLocation = EventLocation(latitude: Double(geo.latitude!)!, longitude: Double(geo.longitude!)!,
                                               street: geo.street!, city: geo.city!, country: geo.country!,
                                               zip: Int(geo.zip!)!, context: context)
        }

        self.departmentFilters = []
        self.eventTypeFilters = []
        self.targetAudienceFilters = []
        if let eventFilters = eventData.filters.eventTypes {
            for eventFilter in eventFilters {
                // TODO: Does this work for adding items to an NSSet?
                eventTypeFilters?.adding(EventFilter(id: eventFilter.id, name: eventFilter.name, context: context))
            }
        }
        if let dtoDepartmentFilters = eventData.filters.departments {
            for eventFilter in dtoDepartmentFilters {
                departmentFilters?.adding(EventFilter(id: eventFilter.id, name: eventFilter.name, context: context))
            }
        }
        if let dtoTargetAudienceFilters = eventData.filters.eventTargetAudience {
            for eventFilter in dtoTargetAudienceFilters {
                self.targetAudienceFilters?.adding(EventFilter(id: eventFilter.id, name: eventFilter.name, context: context))
            }
        }
    }
    
    // MARK: INIT for testing
    convenience init(id: Int, title: String, eventDescription: String, locationName: String?, roomNumber: String?,
         address: String?, status: String, experience: String, eventUrl: URL?, streamUrl: URL?,
         ticketUrl: URL?, venueUrl: URL?, calendarUrl: URL?, photoData: Data?, ticketCost: String?,
         start: Date, end: Date?, allDay: Bool, eventLocation: EventLocation?, departmentFilters: [EventFilter],
        targetAudienceFilters: [EventFilter], eventTypeFilters: [EventFilter], context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = Int64(exactly: id)!
        self.title = title
        self.eventDescription = description
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
        self.departmentFilters = []
        for filter in departmentFilters {
            self.departmentFilters?.adding(filter)
        }
        self.targetAudienceFilters = []
        for filter in targetAudienceFilters {
            self.targetAudienceFilters?.adding(filter)
        }
        self.eventTypeFilters = []
        for filter in eventTypeFilters {
            self.eventTypeFilters?.adding(filter)
        }
    }
}
