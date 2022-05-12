//
//  JSONObjectToSwiftObject.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/10/22.
//

import Foundation

// Called by Injector
struct JSONObjectToEventObject {
    
    static func JSONObjectToEventObject(eventsJSON: EventsSearchFromAPI) -> [Event]{
        var events: [Event] = []
        for middleLayer in eventsJSON.eventMiddleLayer {
            let title: String = {
                if middleLayer.eventJSON.title != nil {
                    return middleLayer.eventJSON.title
                } else {
                    return "No Title For This Event"
                }
            }()
            let description: String = {
                if middleLayer.eventJSON.descriptionText != nil {
                    return middleLayer.eventJSON.descriptionText
                } else {
                    return "No description for this event."
                }
            }()
            let startDate: Date = {
                // format the start date
            }
            let endDate: Date = {
                // format the end date
            }()
            let eventInstanceData = getEventInstanceDateData(eventJSON: eventJSON) // returns a tuple
            let allDay = eventInstanceData.0
            let startDate = eventInstanceData.1
            var endDate = eventInstanceData.2
               
            
            let eventToAdd = Event(title: <#T##String#>, description: <#T##String#>, startDate: <#T##Date#>, endDate: <#T##Date#>,
                                   allDay: <#T##Bool#>, filters: <#T##[Filter]#>, geography: <#T##[Geography]#>, address: <#T##String#>,
                                   url: <#T##URL?#>, localistURL: <#T##URL?#>, icsURL: <#T##URL?#>, photoURL: <#T##URL?#>, venueURL: <#T##URL?#>)
            events.append(eventToAdd)
        }
    }
    
    static func getEventInstanceDateData(eventJSON: JSONEvent) -> (Bool?, Date?, Date?) {
        // Check that there are eventInstances
        if eventJSON.eventInstances == nil {
            return (false, Date(), Date())
        }
        // Check that there is a first item in the instances and then check if it's allDay value is true
        if eventJSON.eventInstances!.indices.contains(0){
            let startStr: String? = eventJSON.eventInstances![0].eventInstance.start
            let endStr: String? = eventJSON.eventInstances![0].eventInstance.end
            
            // TODO Format the start and end dates if they exist
            
            let allDay = eventJSON.eventInstances![0].eventInstance.allDay
            return (allDay, , )
        }
        return (false, Date(), Date())
    }
    
}
