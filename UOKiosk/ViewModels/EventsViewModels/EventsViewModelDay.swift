//
//  EventsViewModel+Day.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/23/22.
//

import Foundation

final class EventsViewModelDay: Identifiable {
    /*
     This is a necessary class for using nested forEach loops in the view such that all of the events
     contained in each instance of this class account for one section's (aka one day's) events.
     
     Note: Before I used [[EventsViewModelEvent]] and tried a nested forEach on that in the loop,
     but then [EventsViewModelEvent] has to be Identifiable and that is impossible because you cannot
     extent the Array<EventsViewModelEvent> type to be indentifiable. Creating this class gets around
     that problem.
     */
    // MARK: Properties
    let id: String = UUID().uuidString
    @Published var dateString: String
    @Published var events: [EventCellViewModel]

    // MARK: Initialization
    init(dateString: String, events: [EventCellViewModel] = []) {
        self.dateString = dateString
        self.events = events
    }
}
