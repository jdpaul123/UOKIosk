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
    static func fetchEventsJSON(urlString: String) async throws -> EventsSearchFromAPI? {
        let url = URL(string: urlString)
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let result: EventsSearchFromAPI
        
        let decoder = JSONDecoder()
        do {
            result = try decoder.decode(EventsSearchFromAPI.self, from: data)
        } catch {
            print("FAILED TO DECODE EVENTS SEARCHFROM API")
            print(error)
            return nil
        }
        return result
    }

    static func fetchJSON<T: Decodable>(urlString: String, completion: @escaping (T?, String) -> Void) async {
        // Try to turn the url string into a Swift URL struct instance
        guard let url = URL(string: urlString) else {
            completion(nil, "url string failed to be turned into a URL struct object")
            return
        }
        
        // Try to get the data from the url. If it fails, report the response
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            completion(nil, "The URL at \(urlString) failed to be decoded into a data object")
            return
        }

        let decoder = JSONDecoder()
        // Try to decode the object to the expected swift type object.
        guard let result = try? decoder.decode(T.self, from: data) else {
            completion(nil, "Data failed to be decoded to the specified swift object")
            return
        }
        // In the case of a success, call the completion with the result
        completion(result, "The data was successfully decoded")
    }
//
//    // GENERAL FUNCTION FOR DECODING JSON
//    static func getJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
//    /*
//    Generic function that will get JSON Data given a url and a decodable, optional, type that conforms to Decoadble and the JSON
//    that is being decoded for the completion
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
