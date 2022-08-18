//
//  EventsViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation
import UIKit

final class EventsViewModelEvent: ObservableObject, Identifiable, Hashable {
    static func == (lhs: EventsViewModelEvent, rhs: EventsViewModelEvent) -> Bool {
        return lhs.id == rhs.id && lhs.image == rhs.image && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(title)
    }
    
    let id: String = UUID().uuidString
    @Published var image: UIImage
    @Published var title: String
    @Published var date: Date
    @Published var dateString: String
    
    init(event: EventModel) {
        self.title = event.title
        // Try to get the image and if there is none use the image that shows the event has no image
        self.image = UIImage.init(data: event.photoData!) ?? UIImage.init(named: "NoImage")!
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        dateString = dateFormatter.string(from: event.start)
        date = event.start
    }
}

final class EventsViewModelDay: Identifiable {
    /*
     This is a necessary class for using nexted forEach loops in the view such that all of the events
     contained in each instance of this class account for one section's (aka one day's) events.
     
     Note: Before I used [[EventsViewModelEvent]] and tried a nested forEach on that in the loop,
     but then [EventsViewModelEvent] has to be Identifiable and that is impossible because you cannot
     extent the Array<EventsViewModelEvent> type to be indentifiable. Creating this class gets around
     that problem.
     */
    let id: String = UUID().uuidString
    @Published var dateString: String
    @Published var events: [EventsViewModelEvent]
    
    init(dateString: String, events: [EventsViewModelEvent] = []) {
        self.dateString = dateString
        self.events = events
    }
}

final class EventsViewModel: ObservableObject, Identifiable {
    /*
     
     */
    let id: String = UUID().uuidString
    @Published var eventsInADay: [EventsViewModelDay]
    func fillData(eventsModel: EventsModel) {
        // Formulate each events date to the day, month, year the event is on into a string
        // Create a grouping of events for each day
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.dateFormat = "EEEE, MMM d" // Example: Sunday, Jun 5
        
        // Fill the dates and events arrays with data
        var compareDateString: String = ""
        for event in eventsModel.events {
            let currDateString: String = dayMonthFormatter.string(from: event.start)
            if compareDateString != currDateString {
                eventsInADay.append(EventsViewModelDay(dateString: currDateString))
                compareDateString = currDateString
            }
            eventsInADay.last!.events.append(EventsViewModelEvent(event: event))
        }
    }
    
    init() {
        self.eventsInADay = []
    }
}
