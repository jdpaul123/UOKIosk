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
    let eventMiddleLayerDto: [EventMiddleLayerDTM]
}


// MARK: Event Middle Layer DTO
struct EventMiddleLayerDTM: Decodable {
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
    let title: String

    let streamURL: String? // stream_url THIS HAD TO BE A STRING

    // url attribute in the JSON, but localist is better, also has to be a STRING type to work
    let url: String? // Attribute is largely useless
    let localistUrl: URL? // URL leads to the page with more info about the event
    let icsUrl: URL? // For subscribing to a calendar for the event
    let photoUrl: URL? // Location of the image for the event
    let venueUrl: URL? // URL to the website for the event venue

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
    let status: String? // live or canceled
    let experience: String? // "inperson" or "hybrid" or "virtual"

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
    let photoId: Int?
    let detailViews: Int?
    let featured: Bool?
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


struct APIService {
    /*
     This is a general API Service that can call any JSON Web API and fill the JSON data into
     a conforming, generic, decodable Swift object.
     */
    enum APIErros: Error {
        case UrlStringToUrlTypeError
        case UrlToDataObjectError
        case DataToObjectTDecodingError
    }
    
    // Often, if the top level DTO object is just an object with an array of objects you can set the variable to the list
    // attribute in the class T return value from this function
    func fetchJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) async {
        // Try to turn the url string into a Swift URL struct instance
        guard let url = URL(string: urlString) else {
            print("URL String could not be converted to a Swift URL object.")
            completion(nil)
            return
        }
        
        // Try to get the data from the url. If it fails, report the response
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            print("The URL at \(urlString) failed to be decoded into a Data object")
            completion(nil)
            return
        }

        let decoder = JSONDecoder()
        // Try to decode the object to the expected swift type object.
        guard let result = try? decoder.decode(T.self, from: data) else {
            print("Data failed to be decoded to \(T.self) swift object")
            completion(nil)
            return
        }
      
        // In the case of a success, call the completion with the result
        print("The data was successfully decoded")
        //return result
        completion(result)
        return
    }
}

let apiService = APIService()

Task {
    await apiService.fetchJSON(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100") { (eventsDto: EventsDto?) in
        guard let eventsDto = eventsDto else {
            print("Didn't work")
            return
        }
        //print(eventsDto)
        for (count, event) in eventsDto.eventMiddleLayerDto.enumerated() {
            print(event.eventDto.title ?? "")
            print(event.eventDto.id)
            print(event.eventDto.photoUrl)
            print(event.eventDto.eventInstances?.count ?? "NO Instances")
            print(count)
            print()
        }
    }
}
