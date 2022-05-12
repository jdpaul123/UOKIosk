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
            let allDay: Bool = {
                // Check that there are eventInstances
                if middleLayer.eventJSON.eventInstances == nil {
                    return false
                }
                // Check that there is a first item in the instances and then check if it's allDay value is true
                if middleLayer.eventJSON.eventInstances!.indices.contains(0) && middleLayer.eventJSON.eventInstances![0].allDay {
                    return true
                }
                return false
            }()
            
            let eventToAdd = Event(title: <#T##String#>, description: <#T##String#>, startDate: <#T##Date#>, endDate: <#T##Date#>,
                                   allDay: <#T##Bool#>, filters: <#T##[Filter]#>, geography: <#T##[Geography]#>, address: <#T##String#>,
                                   url: <#T##URL?#>, localistURL: <#T##URL?#>, icsURL: <#T##URL?#>, photoURL: <#T##URL?#>, venueURL: <#T##URL?#>)
            events.append(eventToAdd)
        }
        for event in events {
            let title = event.title
            let description = event.descriptionText
            let start = event.firstDate
            let end = event.lastDate
        }
    }
    
}
