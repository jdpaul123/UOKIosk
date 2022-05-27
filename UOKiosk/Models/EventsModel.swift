//
//  EventsModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//
/*
 This file acts as the structure for decoding the data from https://calendar.uoregon.edu/api/2/events? into
 Swift. This data should then be put in to structs that will then be used to display the data from the API call.
 
 A good default API URL is below:
     https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100
     This request gets the next 100 future events that are not recurring. I think, based on the filter that the user gives,
     that should determine the url to request data from by appending the filter to the url request
 */
import Foundation


struct EventsModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case eventModelMiddleLayer = "events"
    }
    let eventModelMiddleLayer: [EventModelMiddleLayer]
}


struct EventModelMiddleLayer: Decodable {
    /*
     This struct is needed due to the structure of the JSON from the localist API
     */
    enum CodingKeys: String, CodingKey {
        case eventModel = "event"
    }
    let eventModel: EventModel
}


struct EventModel: Decodable, Identifiable {
    /*
     I included almost all of the attributes that the Localist API provides
     
     I left out some attributes:
     - keywords and tags because they seem to be unused
     - custom fields because they seem to be unused
     - city_id, neighborhood_id, and campud_id because it seems they are always null values
     
     I also have a list of attributes that I call no-use attributes because I am not using them.
     They are below a comment marking them in coding keys and the list of attributes.
     
     Other Notes:
     - Featured value seemed to always be false
     */
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case locationName = "location_name"
        case roomNumber = "room_number"
        case streamURL = "stream_url"
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
        
        // No-use attributes
        case createdAt = "created_at"
        case facebookId = "facebook_id"
        case firstDate = "first_date"
        case lastDate = "last_date"
        case hashtag = "hashtag"
        case urlName = "url_name"
        case userId = "user_id"
        case directions = "directions"
        case allowsReviews = "allows_reviews"
        case allowsAttendance = "allows_attendance"
        case status = "status"
        case experience = "experience"
        case streamInfo = "stream_info"
        case streamEmbedCode = "stream_embed_code"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case kind = "kind"
        case schoolId = "school_id"
        case recurring = "recurring"
        case privateEvent = "private_event"
        case verified = "verified"
        case rejected = "rejected"
        case sponsored = "sponsored"
        case venueId = "venue_id"
        case ticketUrl = "ticket_url"
        case ticketCost = "ticket_cost"
        case photoId = "photo_id"
        case detailViews = "detail_views"
        case featured = "featured"
    }
    let id: Int
    let title: String?

    let streamURL: String? // stream_url THIS HAD TO BE A STRING

    let url: String? // url attribute in the JSON, but localist is better, also has to be a STRING type to work
    let localistUrl: URL? // This is the better URL to use
    let icsUrl: URL?
    let photoUrl: URL?
    let venueUrl: URL?

    let free: Bool?
    let descriptionText: String? // description_text

    let eventInstances: [EventInstances]? // event_instances
    let address: String
    let locationName: String
    let roomNumber: String?

    let geo: Geo?
    let filters: JSONEventFilters
    
    // No-use attributes
    let createdAt: String?
    let facebookId: String?
    let firstDate: String?
    let lastDate: String?
    let hashtag: String?
    let urlName: String?
    let userId: Int?
    let directions: String?
    let allowsReviews: Bool?
    let allowsAttendance: Bool?
    let status: String?
    let experience: String?
    let streamInfo: String?
    let streamEmbedCode: String?
    let createdBy: Int?
    let updatedBy: Int?
    let kind: String?
    let schoolId: Int?
    let recurring: Bool?
    let privateEvent: Bool?
    let verified: Bool?
    let rejected: Bool?
    let sponsored: Bool?
    let venueId: Int?
    let ticketUrl: String?
    let ticketCost: String?
    let photoId: Int?
    let detailViews: Int?
    let featured: Bool?
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
