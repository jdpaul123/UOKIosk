//
//  EventsModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//
import SwiftUI

struct EventsSearch: Decodable {
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
    let events: [Events]
}

struct Events: Decodable {
    enum CodingKeys: String, CodingKey {
        case event = "event"
    }
    let event: Event
}

struct Event: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case locationName = "location_name"
        case streamURL = "stream_url"
        case free = "free"
        case descriptionText = "description_text"
        case eventInstances = "event_instances"
        case address = "address"
        case geo = "geo"
        case photoURL = "photo_url"
        case venueURL = "venue_url"
    }
    let id: Int?
    let title: String?
    let locationName: String? // location_name
    let streamURL: String? // stream_url THIS HAD TO BE A STRING
    let free: Bool?
    let descriptionText: String? // description_text
    struct EventInstances: Decodable {
        enum CodingKeys: String, CodingKey {
            case eventInstance = "event_instance"
        }
        struct EventInstance: Decodable {
            enum CodingKeys: String, CodingKey {
                case start = "start"
                case end = "end"
                case allDay = "all_day"
            }
            let start: String?
            let end: String?
            let allDay: Bool? // all_day
        }
        let eventInstance: EventInstance? // event_instance
    }
    let eventInstances: [EventInstances] // event_instances
    let address: String?
    struct Geo: Decodable {
        enum CodingKeys: String, CodingKey {
            case latitude = "latitude"
            case longitude = "longitude"
            case street = "street"
            case city = "city"
            case state = "state"
            case country = "country"
            case zip = "zip"
        }
        let latitude: String?
        let longitude: String?
        let street: String?
        let city: String?
        let state: String?
        let country: String?
        let zip: String?
    }
    let geo: Geo?
    let photoURL: URL? // photo_url
    let venueURL: URL? // venue_url
}

/* DELETE THIS
class Events {
    let events: [Event]
    
    init(events: [Event]) {
        self.events = events
    }
    
    func fillEvents() -> Void {
        /*
         Fill the events array with all the current events based on the API call to https://calendar.uoregon.edu/api/2/events?page=1
         from Localist API
         */
    }
}
*/
