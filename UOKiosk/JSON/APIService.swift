//
//  GetJSON.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

import Foundation

struct APIService {
    // Take the resulting EventsSearchFromAPI and turn it in to an array of events,
    // each with the nessasary data and filtering categories
    static func fetchEventsJSON(urlString: String) async throws -> EventsSearchFromAPI {
        let url = URL(string: urlString)
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let decoder = JSONDecoder()
        let result = try! decoder.decode(EventsSearchFromAPI.self, from: data)
        return result
    }

// Old method for getting events with a completion that does not throw
//func getEvents(completion: @escaping (EventsSearch?)->()) {
//    guard let url = URL(string: "https://calendar.uoregon.edu/api/2/events?page=1") else {return}
//    URLSession.shared.dataTask(with: url) { data, _, _ in
//        let search = try! JSONDecoder().decode(EventsSearch.self, from: data!)
//
//        DispatchQueue.main.async {
//            completion(search)
//        }
//    }.resume()
//}

//func getJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
//     /*
//     Generic function that will get JSON Data given a url and a decodable, optional, type that conforms to Decoadble and the JSON
//     that is being decoded for the completion
//
//
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
//
//     getJSON(urlString: "https://calendar.uoregon.edu/api/2/events?page=1") { (searchResults: EventsSearch?) in
//         if let searchResults = searchResults {
//             print("loading in events")
//             for result in searchResults.events {
//                 print("Adding event")
//                 events.append(result.event)
//             }
//             eventsLoaded = true
//         } else {
//             print("Data failed to load")
//             // Default test data if the url fails
//             for event in Event.sampleData {
//                 events.append(event)
//             }
//         }
//     }
//    */
//
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
//
//        // Dispatch the competion to be async so we can interact with the app when the data is loading in
//        DispatchQueue.main.async {
//            completion(decodedData)
//        }
//    }.resume()
}
