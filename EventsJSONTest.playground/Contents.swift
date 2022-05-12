import SwiftUI
import Foundation

let dateStr = "2022-05-11T00:00:00-07:00"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
dateFormatter.date(from: dateStr)


//let testTuple = (true, Date(), 0)
//print(testTuple.0)
//print(testTuple.1)
//print(testTuple.2)


struct Event: Identifiable {
    let id: UUID = UUID()
    let title, description: String
    let startDate: Date?
    let endDate: Date? // If allDay == true, then this value is null
    let allDay: Bool
    let filters: [EventFilter] // TODO make a filter class
    let geography: Geography
    let address: String
    let url: URL? // URL attribute value from the JSON. The more important URL is localistURL
    let localistURL: URL? // Event URL
    let icsURL: URL?
    let venueURL: URL?
    // Create an initializer that takes the dates, formatted as the JSON provides,
    // and turn them in to Swift dates
    //let image: UIImage?
}

struct EventFilter {
    let id: Int
    let name: String
}

struct Geography {
    let latitude: Double
    let longitude: Double
    let street: String
    let city: String
    let state: String
    let country: String
    let zip: Int
}

struct JSONObjectToEventObject {
    
    static func JSONObjectToEventObject(eventsJSON: EventsSearchFromAPI) -> [Event]{
        // Create events array that holds all the events from the API get request
        var events: [Event] = []
        // Loop through all the events and put their data into an Event object
        for middleLayer in eventsJSON.eventMiddleLayer {
            
            // Get the title
            let title: String = {
                if middleLayer.eventJSON.title != nil {
                    return middleLayer.eventJSON.title!
                } else {
                    return "No Title For This Event"
                }
            }()
            
            // Get the description
            let description: String = {
                if middleLayer.eventJSON.descriptionText != nil {
                    return middleLayer.eventJSON.descriptionText!
                } else {
                    return "No description for this event."
                }
            }()
            
            // Call the helper function to try to get the date and time data
            let eventInstanceData = getEventInstanceDateData(eventJSON: middleLayer.eventJSON) // returns a tuple
            let allDay: Bool? = eventInstanceData.0
            let startDate: Date? = eventInstanceData.1
            let endDate: Date? = eventInstanceData.2
            
            // Try to get the address
            let address: String = middleLayer.eventJSON.address ?? "No Address"
            
            // Try to get all the url values
            let url = middleLayer.eventJSON.url
            let localistURL = middleLayer.eventJSON.localistURL
            let icsURL = middleLayer.eventJSON.icsURL
            let venueURL = middleLayer.eventJSON.venueURL
            
            // Try to turn the photo at the url in to data then to a UIImage
            let photoURL = middleLayer.eventJSON.photoURL
            /*
            let image: UIImage?
            if let photoURL = photoURL {
                if let data = try? Data(contentsOf: photoURL) {
                    if let imageTry = UIImage(data: data) {
                        image = imageTry
                    }
                    else {
                        image = nil
                    }
                }
                else {
                    image = nil
                }
            } else {
                image = nil
            }
             */
                        
            // Create Geography
            let geo = middleLayer.eventJSON.geo
            var val: String = geo?.latitude ?? ""
            let latitude: Double = Double(val) ?? 0.0
            val = geo?.longitude ?? ""
            let longitude: Double = Double(val) ?? 0.0
            let street: String = geo?.street ?? "No street"
            let city: String = geo?.city ?? "No city"
            let state: String = geo?.state ?? "No state"
            let country: String = geo?.country ?? "No country"
            val = geo?.zip ?? ""
            let zip: Int = Int(val) ?? 0
            let geography = Geography(latitude: latitude, longitude: longitude, street: street, city: city, state: state, country: country, zip: zip)
            
            // create filters
            let JSONfilters = middleLayer.eventJSON.filters
            var filters: [EventFilter] = []
            if let types = JSONfilters.eventTypes {
                for type in types {
                    filters.append(EventFilter(id: type.id ?? 0, name: type.name ?? "No name"))
                }
            }
            
            let eventToAdd = Event(title: title, description: description, startDate: startDate, endDate: endDate, allDay: allDay ?? false,
                                   filters: filters, geography: geography, address: address, url: url, localistURL: localistURL,
                                   icsURL: icsURL, venueURL: venueURL)
            events.append(eventToAdd)
        }
        return events
    }
    
    private static func getEventInstanceDateData(eventJSON: JSONEvent) -> (Bool?, Date?, Date?) {
        // Check that there are eventInstances
        if eventJSON.eventInstances == nil {
            return (false, Date(), Date())
        }
        // Check that there is a first item in the instances and then check if it's allDay value is true
        if eventJSON.eventInstances!.indices.contains(0){
            let startStr: String? = eventJSON.eventInstances![0].eventInstance.start
            let endStr: String? = eventJSON.eventInstances![0].eventInstance.end
            
            // Format the start and end dates if they exist
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
            let start: Date?
            let end: Date?
            if startStr != nil {
               start = dateFormatter.date(from: startStr!)
            } else {
                start = nil
            }
            if endStr != nil {
                end = dateFormatter.date(from: endStr!)
            } else {
                end = nil
            }
            
            
            let allDay = eventJSON.eventInstances![0].eventInstance.allDay
            return (allDay, start, end)
        }
        return (false, Date(), Date())
    }
    
}


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
        //print(data.eventMiddleLayer[0].eventJSON.eventInstances![0].eventInstance.allDay)
        let events = JSONObjectToEventObject.JSONObjectToEventObject(eventsJSON: data)
        for event in events {
            print(event.title)
            print(event.venueURL)
            print(event.geography.zip)
            print("Event starts \(event.startDate). Event ends \(event.endDate).")
            print("Event all day: \(event.allDay)")
            print(event.localistURL)
            print()
        }
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
