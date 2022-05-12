//
//  JSONObjectToSwiftObject.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/10/22.
//

import Foundation
import SwiftUI

// Called by Injector
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
            let startDate: Date = eventInstanceData.1
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
                                   icsURL: icsURL, venueURL: venueURL, image: image)
            events.append(eventToAdd)
        }
        return events
    }
    
    // Helper function to get data about the date and time of the event
    private static func getEventInstanceDateData(eventJSON: JSONEvent) -> (Bool?, Date, Date?) {
        // Check that there are eventInstances
        if eventJSON.eventInstances == nil {
            return (false, Date(), Date())
        }
        // Check that there is a first item in the instances and then check if it's allDay value is true
        if eventJSON.eventInstances!.indices.contains(0){
            let startStr: String = eventJSON.eventInstances![0].eventInstance.start
            let endStr: String? = eventJSON.eventInstances![0].eventInstance.end
            
            // Format the start and end dates if they exist
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
            let start: Date
            let end: Date?
            
            start = dateFormatter.date(from: startStr) ?? Date()
           
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
