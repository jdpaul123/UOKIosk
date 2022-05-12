//
//  Events.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/10/22.
//

import Foundation

struct Event: Identifiable {
    let id: UUID = UUID()
    let title, description: String
    let startDate, endDate: Date
    let allDay: Bool
    let filters: [Filter] // TODO make a filter class
    let geography: [Geography]
    let address: String
    let url: URL? // URL attribute value from the JSON. The more important URL is localistURL
    let localistURL: URL? // Event URL
    let icsURL: URL?
    let photoURL: URL?
    let venueURL: URL?
    // Create an initializer that takes the dates, formatted as the JSON provides,
    // and turn them in to Swift dates
}

struct Filter {
    
}

struct Geography {
    
}


extension Event {
    static let sampleEventData: [Event] =
    [
        // TODO fill in with Events
        Event(title: "Example1Title", description: "Example1Description", startDate: Date(), endDate: Date(), allDay: false,
              filters: [Filter()], geography: [Geography()], address: "Example1 Address", url: URL(string: "youtube.com"),
              localistURL: nil, icsURL: nil, photoURL: nil, venueURL: nil)
    ]
}
