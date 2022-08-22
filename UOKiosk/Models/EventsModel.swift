//
//  EventsModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import Foundation
import CoreLocation

final class EventsModel {
    var events: [EventModel]
    
    init() {
        events = []
    }
    
    init(eventsData: EventsDto?) {
        guard let eventsData = eventsData else {
            self.events = []
            print("The EventsModel did not recieve any data. It only revieved a nil value for the data.")
            return
        }
        self.events = []
        for middle in eventsData.eventMiddleLayerDto {
            self.events.append(EventModel(eventData: middle.eventDto))
        }
    }
    
    public func setData(eventsData: EventsDto) {
        for middle in eventsData.eventMiddleLayerDto {
            self.events.append(EventModel(eventData: middle.eventDto))
        }
    }
}

final class EventModel {
    let id: Int
    let title: String
    let description: String // This attribute is called eventDescription for core data
    
    // location and roomNumber used for displaying the location in the event detail view
    let locationName: String?
    let roomNumber: String?
    let address: String? // Address is NOT used for naming the locations in the event detail view
    
    let status: String // Live or canceled: Default = live
    let experience: String // inperson, hybrid, or virtual: Default = "assumed inperson"
    
    // All url values
    let eventUrl: URL? // Use for linking to the events website
    let streamUrl: URL?
    let ticketUrl: URL?
    let venueUrl: URL?
    let calendarUrl: URL?
    
    // Data for the photo loaded from the api
    let photoData: Data?
    
    let ticketCost: String?
    
    // Data on the time
    let start: Date
    let end: Date?
    let allDay: Bool
    
    // location is set from the lat lon of the event, if the web api provides it
    let eventCoreLocationData: CLLocation? // This attribute is beoing omitted from the Core Data model,
    // but it can be re-created using the latitude and longitude values
    let eventLocation: EventLocationModel?
    
    var filters: [EventFilterModel]
    
    init(eventData: EventDto) {
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
        
        self.id = eventData.id
        self.title = eventData.title
        self.description = eventData.descriptionText
        
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

        self.eventCoreLocationData = { () -> CLLocation? in
            guard let geo = eventData.geo else {
                return nil
            }
            guard let latStr = geo.latitude else {
                return nil
            }
            guard let lonStr = geo.longitude else {
                return nil
            }
            guard let lat = Double(latStr) else {
                return nil
            }
            guard let lon = Double(lonStr) else {
                return nil
            }

            return CLLocation(latitude: lat, longitude: lon)
        }()
        
        if eventData.geo == nil || eventData.geo!.latitude == nil || eventData.geo!.longitude == nil ||
            eventData.geo!.city == nil || eventData.geo!.country == nil || eventData.geo!.state == nil ||
            eventData.geo!.street == nil || eventData.geo!.zip == nil ||
            Double(eventData.geo!.latitude!) == nil || Double(eventData.geo!.longitude!) == nil ||
            Int(eventData.geo!.zip!) == nil
        {
            self.eventLocation = nil
        }
        else {
            self.eventLocation = EventLocationModel(latitude: Double(eventData.geo!.latitude!)! , longitude: Double(eventData.geo!.longitude!)!,
                                                    street: eventData.geo!.street!, city: eventData.geo!.city!,
                                                    country: eventData.geo!.country!, zip: Int(eventData.geo!.zip!)!)
        }

        // TODO: Seperate filters into their 3 types
        self.filters = []
        if let eventFilters = eventData.filters.eventTypes {
            for eventFilter in eventFilters {
                filters.append(EventFilterModel(id: eventFilter.id, name: eventFilter.name))
            }
        }
    }
    
    // MARK: INIT for testing
    init(id: Int, title: String, description: String, locationName: String?, roomNumber: String?,
         address: String?, status: String, experience: String, eventUrl: URL?, streamUrl: URL?,
         ticketUrl: URL?, venueUrl: URL?, calendarUrl: URL?, photoData: Data?, ticketCost: String?,
         start: Date, end: Date?, allDay: Bool, eventCoreLocationData: CLLocation?,
         eventLocation: EventLocationModel?, filters: [EventFilterModel]) {
        self.id = id
        self.title = title
        self.description = description
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
        self.eventCoreLocationData = eventCoreLocationData
        self.eventLocation = eventLocation
        self.filters = filters
    }
}

final class EventLocationModel {
    let latitude: Double
    let longitude: Double
    let street: String
    let city: String
    let country: String
    let zip: Int
    
    init(latitude: Double, longitude: Double, street: String, city: String, country: String, zip: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.street = street
        self.city = city
        self.country = country
        self.zip = zip
    }
    
    init (geoData: GeoDto) {
        self.latitude = Double(geoData.latitude!)!
        self.longitude = Double(geoData.longitude!)!
        self.street = geoData.street!
        self.city = geoData.city!
        self.country = geoData.country!
        self.zip = Int(geoData.zip!)!
    }
}

final class EventFilterModel {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
