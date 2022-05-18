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
    
    let allDay: Bool
    let isEndDate: Bool
    let startDate: Date
    let endDate: Date? // If allDay == true, then this value is null
    let startDay: String // Ex. Thursday, June 2
    let startTime: String // Ex. 12:30 PM
    let endDay: String
    let endTime: String
    
    let filters: [EventFilter] // TODO make a filter class
    let geography: Geography
    
    let address: String
    let locationName: String
    let roomNumber: String
    
    //let url: URL? // URL attribute value from the JSON. The more important URL is localistURL
    let eventURL: URL? // Event URL
    let icsURL: URL?
    let venueURL: URL?
    // Create an initializer that takes the dates, formatted as the JSON provides,
    // and turn them in to Swift dates
    let image: UIImage?
    
    init(title: String, description: String, startDate: Date, endDate: Date?, allDay: Bool,
         filters: [EventFilter], geography: Geography, address: String, locationName: String, roomNumber: String,
         /*url: URL?, */localistURL: URL?, icsURL: URL?, venueURL: URL?, image: UIImage?) {
        self.title = title
        self.description = description
        
        self.allDay = allDay
        self.isEndDate = {
            if endDate != nil {
                return true
            }
            return false
        }()
        self.startDate = startDate
        self.endDate = endDate
        self.startDay = self.startDate.formatted(date: .complete, time: .omitted)
        self.endDay = self.endDate?.formatted(date: .complete, time: .omitted) ?? ""
        self.startTime = self.startDate.formatted(date: .omitted, time: .shortened)
        self.endTime = self.endDate?.formatted(date: .omitted, time: .shortened) ?? ""
        
        self.address = address
        self.locationName = locationName
        self.roomNumber = roomNumber
        
        
        self.filters = filters
        self.geography = geography

        //self.url = url
        self.eventURL = localistURL
        self.icsURL = icsURL
        self.venueURL = venueURL
        self.image = image
    }
    
    func getDateRange() -> String {
        // Check if the event is all day
        if allDay {
            // the range is just a start
            return startDay
        }
        else if isEndDate {
            // The range is either a start and an end or just a start if it is a one day event
            if startDay == endDay {
                return startDay
            }
            return "\(startDay) - \(endDay)"
        } else {
            // If not returned yet, then there is only a start date provided, but no end date, and it is not marked allDay
            // This case should never happen unless the JSON was inputted incorrectly
            return startDay
        }
    }
    
    func getTimeRange() -> String {
        if allDay {
            // Only a start time if it is all day
            return "\(startTime) - All Day"
        } else if isEndDate {
            // If there is an end time then we have a range
            return "\(startTime) - \(endTime)"
        } else {
            // This is only triggered if the event is not all day and there is no provided end time
            return "\(startTime)"
        }
    }
}

// MARK: EventFilter
// is a type that is used within Event objects
struct EventFilter {
    let id: Int
    let name: String
}

// MARK: Geography
// is a type that is used within Event objects
struct Geography {
    let latitude: Double
    let longitude: Double
    let street: String
    let city: String
    let state: String
    let country: String
    let zip: Int
}


// MARK: Event Extension for sample data
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
    
    static let sampleEventDecription = "The Visual Arts Team is excited to present I Am More Than Who You See, an exhibition by Malik Lovette and Kayla Lockwood, previously exhibited in the Jordan Schnitzer Museum of Art. Find the Visual Arts Team on Instagram @uovisualarts or Facebook @visualartsteam, where you can see exhibition updates, behind the scenes looks, and video artist talks! This show runs March 25 through May 20 in the EMU Aperture Gallery, with a reception in the gallery April 21th at 7 PM. Inspired by Cephas Williams’ 56 Black Men campaign, I Am More Than Who You See is an exhibition centered around a series of workshops held for UO students focusing on identity and misrepresentation through personal aesthetics. This project was led and curated by photographers and UO students, Malik Lovette (MArch, 2024) and Kayla Lockwood (ATCH BFA, 2022). The exhibition documents multiple community conversations with UO students, documenting their experiences surrounding stereotyping. The project team represented each students’ authentic view of their identity with the critical and reflective dispositions that accompany their personal development."
    static let startDate = Date(timeIntervalSince1970: 1652373000)
    static let endDate = Date(timeIntervalSince1970: 1652396400)
    static let sampleEventData: [Event] =
    [
        // TODO fill in with Events
        Event(title: "Example1: The Great Event!", description: sampleEventDecription, startDate: startDate, endDate: endDate, allDay: false,
              filters: [sampleFilters[0], sampleFilters[1]], geography: sampleGeography, address: "123 Emerald Street, Eugene, OR",
              locationName: "EMU Building", roomNumber: "Women's Center",
              /*url: nil,*/ localistURL: URL(string: "https://calendar.uoregon.edu/event/rgb#.YnygrpPMI-R"), icsURL: nil, venueURL: nil,
              image: sampleImage)
    ]
}
