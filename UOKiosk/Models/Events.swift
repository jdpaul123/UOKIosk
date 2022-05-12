//
//  Events.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/10/22.
//

import Foundation
import UIKit

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
    let image: UIImage?
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


extension Event {
    static let sampleFilters: [EventFilter] = [
        EventFilter(id: 4, name: "Fun"),
        EventFilter(id: 5, name: "Sports"),
        EventFilter(id: 6, name: "Club")
    ]
    
    static let sampleGeography: Geography = Geography(latitude: 44.03603, longitude: 123.07314, street: "123 Emerald St.", city: "Eugene", state: "OR", country: "USA", zip: 97403)
    
    static let sampleImage: UIImage? = {
        if let photoURL = URL(string: "https://localist-images.azureedge.net/photos/39421797028473/huge/899ae0564cd6542b9ca410eecf2eb1969d8cde1f.jpg") {
            if let data = try? Data(contentsOf: photoURL) {
                if let image = UIImage(data: data) {
                    return image
                }
                return nil
            }
            return nil;
        }
        return nil
    }()
    
    static let sampleEventData: [Event] =
    [
        // TODO fill in with Events
        Event(title: "Example1", description: "Example1 description.", startDate: Date(), endDate: Date(), allDay: false,
              filters: [sampleFilters[0], sampleFilters[1]], geography: sampleGeography, address: "123 Emerald Street, Eugene, OR",
              url: nil, localistURL: URL(string: "https://calendar.uoregon.edu/event/rgb#.YnygrpPMI-R"), icsURL: nil, venueURL: nil,
              image: sampleImage)
    ]
}
