//
//  JSONObjectToSwiftObject.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/10/22.
//

import Foundation
import SwiftUI

// Called by Injector to turn models into view models
struct ModelToViewModelService {
    static func eventModelToEventViewModel(eventsModel: EventsModel) -> EventsViewModel{
        /*
         This is the mdidleman function for turning the Event Models into Event View Models. The values are extracted from the models
         or set to a default value if the value from the Localist API call is empty. It also splits the events from the model into
         view model events split into sub-arrays based on the day of the event
         */
        
        // Create events array that holds all the events from the API get request
        var eventViewModels: [EventViewModel] = []
        // Loop through all the events and put their data into an Event object
        for middleLayer in eventsModel.eventModelMiddleLayer {
            // Get the title
            let title: String = {
                if let title = middleLayer.eventModel.title {
                    return title
                } else {
                    return "No Title For This Event"
                }
            }()
            
            // Get the description
            let description: String = {
                if middleLayer.eventModel.descriptionText != nil {
                    return middleLayer.eventModel.descriptionText!
                } else {
                    return "No description for this event."
                }
            }()
            
            let id = middleLayer.eventModel.id
            
            // Call the helper function to try to get the date and time data
            let eventInstanceData = getEventInstanceDateData(eventModel: middleLayer.eventModel)// returns a tuple
            let allDay: Bool? = eventInstanceData.0
            let startDate: Date = eventInstanceData.1
            let endDate: Date? = eventInstanceData.2
            
            // Try to get the address
            let address: String = middleLayer.eventModel.address
            let locationName = middleLayer.eventModel.locationName
            let roomNumber: String = middleLayer.eventModel.roomNumber ?? ""
            
            // Try to get all the url values
            let localistURL = middleLayer.eventModel.localistUrl
            let icsURL = middleLayer.eventModel.icsUrl
            let venueURL = middleLayer.eventModel.venueUrl
            
            // Try to turn the photo at the url in to data then to a UIImage
            let photoURL = middleLayer.eventModel.photoUrl
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
            let geo = middleLayer.eventModel.geo
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
            let JSONfilters = middleLayer.eventModel.filters
            var filters: [EventFilter] = []
            if let types = JSONfilters.eventTypes {
                for type in types {
                    filters.append(EventFilter(id: type.id ?? 0, name: type.name ?? "No name"))
                }
            }
            
            let eventToAdd = EventViewModel(title: <#T##String#>, description: <#T##String#>, startDate: <#T##Date#>, endDate: <#T##Date?#>,
                                            allDay: <#T##Bool#>, filters: <#T##[EventFilter]#>, geography: <#T##Geography#>,
                                            address: <#T##String#>, locationName: <#T##String#>, roomNumber: <#T##String#>,
                                            localistURL: <#T##URL?#>, icsURL: <#T##URL?#>, venueURL: <#T##URL?#>, image: <#T##UIImage?#>)
            eventViewModels.append(eventToAdd)
        }
        return EventsViewModel(eventsViewModel: eventViewModels)
    }
    
    // Helper function to get data about the date and time of the event
    private static func getEventInstanceDateData(eventModel: EventModel) -> (Bool?, Date, Date?) {
        // Check that there are eventInstances
        if eventModel.eventInstances == nil {
            return (false, Date(), Date())
        }
        // Check that there is a first item in the instances and then check if it's allDay value is true
        if eventModel.eventInstances!.indices.contains(0){
            let startStr: String = eventModel.eventInstances![0].eventInstance.start
            let endStr: String? = eventModel.eventInstances![0].eventInstance.end
            
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
            
            let allDay = eventModel.eventInstances![0].eventInstance.allDay
            return (allDay, start, end)
        }
        return (false, Date(), Date())
    }
    
}
