//
//  EventsModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//
/*
 This file acts as the structure for decoding the data from https://calendar.uoregon.edu/api/2/events?page=1 into
 Swift. This data should then be put in to structs that will then be used to display the data from the API call.
 */
import Foundation


struct EventsSearchFromAPI: Decodable {
    enum CodingKeys: String, CodingKey {
        case eventMiddleLayer = "events"
    }
    let eventMiddleLayer: [JSONEventMiddleLayer]
}


struct JSONEventMiddleLayer: Decodable {
    enum CodingKeys: String, CodingKey {
        case eventJSON = "event"
    }
    let eventJSON: JSONEvent
}


struct JSONEvent: Decodable, Identifiable {
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
        case url = "url"
        case icsURL = "localist_ics_url"
        case filters = "filters"
        case localistURL = "localist_url"
    }
    let id: Int?
    let title: String?
    let locationName: String? // location_name

    let streamURL: String? // stream_url THIS HAD TO BE A STRING

    let icsURL: URL?
    let photoURL: URL?
    let venueURL: URL?
    let url: URL? // url attribute in the JSON, but localist is better
    let localistURL: URL? // This is the better URL to use

    let free: Bool?
    let descriptionText: String? // description_text

    let eventInstances: [EventInstances]? // event_instances
    let address: String?

    let geo: Geo?
    let filters: JSONEventFilters
}


struct JSONEventFilters: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case departments = "departments"
        case eventTargetAudience = "event_target_audience"
        case eventTypes = "event_types"
    }
    let departments: [JSONEventFilter]?
    let eventTargetAudience: [JSONEventFilter]?
    let eventTypes: [JSONEventFilter]?
     
}


struct JSONEventFilter: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
    let name: String?
    let id: Int?
}


struct EventInstances: Decodable {
    enum CodingKeys: String, CodingKey {
         case eventInstance = "event_instance"
     }
     let eventInstance: EventInstance
     
 }

struct EventInstance: Decodable {
    enum CodingKeys: String, CodingKey {
        case start = "start"
        case end = "end"
        case allDay = "all_day"
    }
    let start: String
    let end: String?
    let allDay: Bool
}

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
