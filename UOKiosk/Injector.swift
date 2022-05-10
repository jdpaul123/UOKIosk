//
//  Dependency.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

import SwiftUI

class Injector: ObservableObject {
    /*
     Location of instantiation for all dependency creation for the program
     */
    
    //static let shared: Injector = Injector()
    
    @Published var events: [Event]
    
    init() {
        self.events = [] // Will later be filled with events when needed
    }
}

extension Injector {
    static let sampleEventData: [Event] =
    [
        Event(id: 12393, title: "Test1", locationName: "House1", streamURL: nil, free: nil, descriptionText: "This event is going to be big.", eventInstances: [Event.EventInstances(eventInstance: .none)], address: nil, geo: Event.Geo(latitude: "", longitude: "", street: "", city: "", state: "", country: "", zip: ""), photoURL: nil, venueURL: nil),
        Event(id: 21380, title: "Test2", locationName: "Apt1", streamURL: nil, free: nil, descriptionText: nil, eventInstances: [Event.EventInstances(eventInstance: .none)], address: nil, geo: Event.Geo(latitude: "", longitude: "", street: "", city: "", state: "", country: "", zip: ""), photoURL: nil, venueURL: nil),
        Event(id: 54389, title: "Test3", locationName: "Museum1", streamURL: nil, free: nil, descriptionText: nil, eventInstances: [Event.EventInstances(eventInstance: .none)], address: nil, geo: Event.Geo(latitude: "", longitude: "", street: "", city: "", state: "", country: "", zip: ""), photoURL: nil, venueURL: nil),
    ]
}
