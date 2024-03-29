//
//  MockEventsModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation
import CoreData
@testable import UOKiosk

#if DEBUG
class MockEventsModelData {
    let events: [Event] = []
    let event: Event
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    init() {
        event = Event(id: 1234, title: "Example Event", eventDescription: "This event has a description of many words. It is going to be a great event where many things will happen. You won't want to miss it or you'll regret it.",
                      locationName: "Example Hall", roomNumber: "Example Amazing Gallery",
                      address: "1234 Example Boulevard, Eugene, OR", status: "live", experience: "inperson",
                      eventUrl: URL(string: "https://calendar.uoregon.edu/event/avoidance")!,
                      streamUrl: nil,
                      ticketUrl: URL(string: "https://www.eventbrite.com/e/breaking-the-silence-an-oral-history-of-lgbtq-veterans-and-service-member-tickets-620410563697")!,
                      venueUrl: URL(string: "https://calendar.uoregon.edu/LawrenceHall")!,
                      calendarUrl: URL(string: "https://calendar.uoregon.edu/event/avoidance.ics"),
                      photoData: nil,
                      photoUrl: URL(string: "https://www.youtube.com"),
                      ticketCost: "$25.00",
                      start: Date(timeIntervalSinceNow: TimeInterval(60*25)), end: Date(timeIntervalSinceNow: TimeInterval(60*220)),
                      allDay: false,
                      eventLocation: EventLocation(geoDto: GeoDto(latitude: "44.047367", longitude: "-123.07431", street: "1190 Franklin Blvd", city: "Eugene", state: "OR", country: "US", zip: "97401"),
                                                   context: context),
                      departmentFilters: [EventFilter(id: 16403, name: "Museum of Natural and Cultural History", context: context),
                                          EventFilter(id: 22996, name: "General Public", context: context)],
                      targetAudienceFilters: [EventFilter(id: 22994, name: "All Students", context: context)],
                      eventTypeFilters: [EventFilter(id: 14466, name: "Arts & Culture", context: context),
                                         EventFilter(id: 14468, name: "Music", context: context),
                                         EventFilter(id: 14830, name: "Diversity and Multiculturalism", context: context),
                                         EventFilter(id: 25811, name: "Diversity", context: context),
                                         EventFilter(id: 43800, name: "Black and African American", context: context)],
                      context: context)
    }
//    let eventsModel: EventsModel
//
//    init() {
//        eventsModel = EventsModel()
//
//        let eventLocation1 = EventLocationModel(latitude: 44.042946, longitude: -123.068481, street: "1680 E 15th Ave", city: "Eugene", country: "US", zip: 97403)
//
//        let filters1 = [
//                        // Departments
//                        EventFilterModel(id: 16403, name: "Museum of Natural and Cultural History"),
//                        EventFilterModel(id: 22996, name: "General Public"),
//                        // Event Target Audience
//                        EventFilterModel(id: 22994, name: "All Students"),
//                        // Event types
//                        EventFilterModel(id: 14466, name: "Arts & Culture"),
//                        EventFilterModel(id: 14468, name: "Music"),
//                        EventFilterModel(id: 14830, name: "Diversity and Multiculturalism"),
//                        EventFilterModel(id: 25811, name: "Diversity"),
//                        EventFilterModel(id: 43800, name: "Black and African American")]
//
//        let event1 = EventModel(id: 1, title: "event1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//                                locationName: "location1", roomNumber: "room1", address: "1 example st", status: "live", experience: "inperson",
//                                eventUrl: URL(string: "https://calendar.uoregon.edu/event/peace_corps_application_workshop_8992"),
//                                streamUrl: nil,
//                                ticketUrl: URL(string: "https://uoregon2.radiusbycampusmgmt.com/ssc/eform/zKzx6RTA8670x67dM.ssc"),
//                                venueUrl: URL(string: "https://calendar.uoregon.edu/outdoor_program_barn"),
//                                calendarUrl: URL(string: "https://calendar.uoregon.edu/event/oregon_executive_mba_building_and_classroom_tour081022_6.ics"),
//                                photoData: Data(),
//                                ticketCost: "Included with regular museum admission. Free for MNCH members and UO ID card holders. Show your Oregon Trail or other EBT card for an admission discount.",
//                                start: Date(), end: Date(), allDay: false,
//                                eventCoreLocationData: nil,
//                                eventLocation: eventLocation1,
//                                filters: filters1)
//
//        let eventLocation2 = EventLocationModel(latitude: 44.042946, longitude: -123.068481, street: "1680 E 15th Ave", city: "Eugene", country: "US", zip: 97403)
//
//        let filters2 = [
//                        // Departments
//                        EventFilterModel(id: 14387, name: "Division of Student Life"),
//                        EventFilterModel(id: 14492, name: "Division of Equity and Inclusion"),
//                        EventFilterModel(id: 16079, name: "Office of the Dean of Students"),
//                        EventFilterModel(id: 15663, name: "Center on Diversity and Community (CoDaC)"),
//                        EventFilterModel(id: 25686, name: "Multicultural Center (MCC)"),
//                        // Event Target Audience
//                        EventFilterModel(id: 22994, name: "All Students"),
//                        // Event types
//                        EventFilterModel(id: 14396, name: "Student Life"),
//                        EventFilterModel(id: 14466, name: "Arts & Culture"),
//                        EventFilterModel(id: 14467, name: "Film/Movie"),
//                        EventFilterModel(id: 14827, name: "Free"),
//                        EventFilterModel(id: 25811, name: "Diversity and Multiculturalism"),
//                        EventFilterModel(id: 15085, name: "LGBT"),
//                        EventFilterModel(id: 25811, name: "Diversity"),
//                        EventFilterModel(id: 26464, name: "Recurring"),
//                        EventFilterModel(id: 43802, name: "Non-Traditional"),
//                        EventFilterModel(id: 129792, name: "Women and Gender")]
//
//        let event2 = EventModel(id: 2, title: "event2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//                                locationName: nil, roomNumber: nil, address: nil, status: "live", experience: "virtual",
//                                eventUrl: URL(string: "https://calendar.uoregon.edu/event/lgbt_virtual_movie_night_1010"),
//                                streamUrl: nil,
//                                ticketUrl: URL(string: "https://uoregon2.radiusbycampusmgmt.com/ssc/eform/zKzx6RTA8670x67dM.ssc"),
//                                venueUrl: nil,
//                                calendarUrl: URL(string: "https://calendar.uoregon.edu/event/lgbt_virtual_movie_night_1010.ics"),
//                                photoData: Data(),
//                                ticketCost: "$0",
//                                start: Date(), end: Date(), allDay: false,
//                                eventCoreLocationData: nil,
//                                eventLocation: eventLocation2,
//                                filters: filters2)
//
//        eventsModel.events = [event1, event2]
//    }
}
#endif
