//
//  EventsDTO.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI

// MARK: Events Data Transfer Object (DTO)
struct EventsDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case eventMiddleLayerDto = "events"
    }
    let eventMiddleLayerDto: [EventMiddleLayerDto]
}


// MARK: Event Middle Layer DTO
struct EventMiddleLayerDto: Decodable {
    /*
     This struct is needed due to the structure of the JSON from the localist API
     */
    enum CodingKeys: String, CodingKey {
        case eventDto = "event"
    }
    let eventDto: EventDto
}


// MARK: Event DTO
struct EventDto: Decodable, Identifiable {
    /*
     I included almost all of the attributes that the Localist API provides
     
     I left out some attributes that are included in the provided JSON data:
     - keywords and tags because they seem to be unused
     - custom fields because they seem to be unused
     - city_id, neighborhood_id, and campud_id because it seems they are always null values
     
     Other Notes:
     - Featured value seemed to always be false
     */
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case locationName = "location_name"
        case roomNumber = "room_number"
        case streamUrl = "stream_url"
        case free = "free"
        case descriptionText = "description_text"
        case eventInstances = "event_instances"
        case address = "address"
        case geo = "geo"
        case photoUrl = "photo_url"
        case venueUrl = "venue_url"
        case url = "url"
        case icsUrl = "localist_ics_url"
        case filters = "filters"
        case localistUrl = "localist_url"
        case status = "status"
        case experience = "experience"
        case ticketUrl = "ticket_url"
        case ticketCost = "ticket_cost"
    }
    let id: Int
    let title: String

    let streamUrl: String?

    let url: String? // DO NOT USE THIS URL
    let localistUrl: String? // USE THIS URL. It leads to the page with more info about the event
    let icsUrl: String? // For subscribing to a calendar for the event
    let photoUrl: String? // Location of the image for the event
    let venueUrl: String? // URL to the website for the event venue

    let free: Bool
    let descriptionText: String

    let eventInstances: [EventInstancesDto]?
    let address: String?
    let locationName: String?
    let roomNumber: String?

    let geo: GeoDto?
    let filters: EventFiltersDto
    
    // Ticket Information
    let ticketUrl: String?
    let ticketCost: String?
    
    // About event
    let status: String? // Possible values: "live" or "canceled"
    let experience: String? // Possible values: "inperson" or "hybrid" or "virtual"
}

// MARK: Event Filters DTO
struct EventFiltersDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case departments = "departments"
        case eventTargetAudience = "event_target_audience"
        case eventTypes = "event_types"
    }
    let departments: [EventFilterDto]?
    let eventTargetAudience: [EventFilterDto]?
    let eventTypes: [EventFilterDto]?
}

// MARK: Event Filter DTO
struct EventFilterDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
    let name: String
    let id: Int
}


// MARK: Event Instances DTO
struct EventInstancesDto: Decodable {
    enum CodingKeys: String, CodingKey {
         case eventInstance = "event_instance"
     }
     let eventInstance: EventInstanceDto
     
 }

// MARK: Event Instance DTO
struct EventInstanceDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case start = "start"
        case end = "end"
        case allDay = "all_day"
    }
    let start: String
    let end: String?
    let allDay: Bool
}

// MARK: Geo DTO
struct GeoDto: Decodable {
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
