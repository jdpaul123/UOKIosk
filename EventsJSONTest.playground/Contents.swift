import SwiftUI

let dateStr = "2022-05-11T00:00:00-07:00"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
dateFormatter.date(from: dateStr)



let testTuple = (true, Date(), 0)
print(testTuple.0)
print(testTuple.1)
print(testTuple.2)

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
    let start: String?
    let end: String?
    let allDay: Bool?
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


func fetch(urlString: String) async throws -> EventsSearchFromAPI {
    let url = URL(string: urlString)
    let (data, _) = try await URLSession.shared.data(from: url!)
    
    let decoder = JSONDecoder()
    let result = try! decoder.decode(EventsSearchFromAPI.self, from: data)
    return result
}

Task {
    do {
        let data = try await fetch(urlString: "https://calendar.uoregon.edu/api/2/events?page=1")
        print(data.eventMiddleLayer[0].eventJSON.eventInstances![0].eventInstance.allDay)
        print("success")
    } catch {
        print("failed")
    }
}

//func getJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
//    /*
//     Generic function that will get JSON Data given a url and a decodable, optional, type that conforms to Decoadble and the JSON
//     that is being decoded for the completion
//
//     Example call for getting event data:
//     getJSON(urlString: "https://calendar.uoregon.edu/api/2/events?page=1") { (searchResults: EventsSearch?) in
//         if let searchResults = searchResults {
//             for event in searchResults.events {
//                 print(event.event?.title ?? "No Title")
//                 print(event.event?.photoURL ?? "No Photo URL")
//             }
//         } else {
//             print("Failed")
//         }
//     }
//     */
//    guard let url = URL(string: urlString) else {
//        return
//    }
//    let request = URLRequest(url: url)
//    URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print(error.localizedDescription)
//            completion(nil)
//            print("DONE2")
//            return
//        }
//        guard let data = data else {
//            completion(nil)
//            print("Data is nil in getJSON() completion")
//            return
//        }
//        let decoder = JSONDecoder()
//        guard let decodedData = try? decoder.decode(T.self, from: data) else {
//            completion(nil)
//            print("Failed to decode the data in getJSON()")
//            return
//        }
//        completion(decodedData)
//    }.resume()
//}
//
//
//struct EventsSearch: Decodable, Identifiable {
//    enum CodingKeys: String, CodingKey {
//        case events = "events"
//    }
//    let events: [Events]
//    let id = UUID()
//}
//
//struct Events: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case event = "event"
//    }
//    let event: Event?
//}
//
//struct Event: Decodable, Identifiable {
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case title = "title"
//        case locationName = "location_name"
//        case streamURL = "stream_url"
//        case free = "free"
//        case descriptionText = "description_text"
//        case eventInstances = "event_instances"
//        case address = "address"
//        case geo = "geo"
//        case photoURL = "photo_url"
//        case venueURL = "venue_url"
//    }
//    let id: Int?
//    let title: String?
//    let locationName: String? // location_name
//    let streamURL: String? // stream_url THIS HAD TO BE A STRING
//    let free: Bool?
//    let descriptionText: String? // description_text
//    struct EventInstances: Decodable {
//        enum CodingKeys: String, CodingKey {
//            case eventInstance = "event_instance"
//        }
//        struct EventInstance: Decodable {
//            enum CodingKeys: String, CodingKey {
//                case start = "start"
//                case end = "end"
//                case allDay = "all_day"
//            }
//            let start: String?
//            let end: String?
//            let allDay: Bool? // all_day
//        }
//        let eventInstance: EventInstance? // event_instance
//    }
//    let eventInstances: [EventInstances] // event_instances
//    let address: String?
//    struct Geo: Decodable {
//        enum CodingKeys: String, CodingKey {
//            case latitude = "latitude"
//            case longitude = "longitude"
//            case street = "street"
//            case city = "city"
//            case state = "state"
//            case country = "country"
//            case zip = "zip"
//        }
//        let latitude: String?
//        let longitude: String?
//        let street: String?
//        let city: String?
//        let state: String?
//        let country: String?
//        let zip: String?
//    }
//    let geo: Geo?
//    let photoURL: URL? // photo_url
//    let venueURL: URL? // venue_url
//}
//
//getJSON(urlString: "https://calendar.uoregon.edu/api/2/events?page=1") { (searchResults: EventsSearch?) in
//    if let searchResults = searchResults {
//        for event in searchResults.events {
//            print(event.event?.title ?? "No Title")
//            print(event.event?.photoURL ?? "No Photo URL")
//            print(event.event?.address ?? "No address")
//            print(event.event?.locationName ?? "No location name")
//            print(event.event?.streamURL ?? "No stream URL")
//            print(event.event?.geo?.city ?? "No geo.city")
//            print(event.event?.venueURL ?? "No venue url")
//            print()
//
//        }
//    } else {
//        print("Failed")
//    }
//}



// OLD EVENTS MODEL
//struct EventsSearch: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case events = "events"
//    }
//    struct Events: Decodable {
//        enum CodingKeys: String, CodingKey {
//            case event = "event"
//        }
//        struct Event: Decodable {
//            enum CodingKeys: String, CodingKey {
//                case id = "id"
//                case title = "title"
//                case locationName = "location_name"
//                case streamURL = "stream_url"
//                case free = "free"
//                case descriptionText = "description_text"
//                case eventInstances = "event_instances"
//                case address = "address"
//                case geo = "geo"
//                case photoURL = "photo_url"
//                case venueURL = "venue_url"
//            }
//            let id: Int?
//            let title: String?
//            let locationName: String? // location_name
//            let streamURL: String? // stream_url THIS HAD TO BE A STRING
//            let free: Bool?
//            let descriptionText: String? // description_text
//            struct EventInstances: Decodable {
//                enum CodingKeys: String, CodingKey {
//                    case eventInstance = "event_instance"
//                }
//                struct EventInstance: Decodable {
//                    enum CodingKeys: String, CodingKey {
//                        case start = "start"
//                        case end = "end"
//                        case allDay = "all_day"
//                    }
//                    let start: String?
//                    let end: String?
//                    let allDay: Bool? // all_day
//                }
//                let eventInstance: EventInstance? // event_instance
//            }
//            let eventInstances: [EventInstances] // event_instances
//            let address: String?
//            struct Geo: Decodable {
//                enum CodingKeys: String, CodingKey {
//                    case latitude = "latitude"
//                    case longitude = "longitude"
//                    case street = "street"
//                    case city = "city"
//                    case state = "state"
//                    case country = "country"
//                    case zip = "zip"
//                }
//                let latitude: String?
//                let longitude: String?
//                let street: String?
//                let city: String?
//                let state: String?
//                let country: String?
//                let zip: String?
//            }
//            let geo: Geo?
//            let photoURL: URL? // photo_url
//            let venueURL: URL? // venue_url
//        }
//        let event: Event?
//    }
//    let events: [Events]
//}

