//
//  EventsListViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Collections

class EventsListViewModel: ObservableObject {
    let eventsRepository: EventsRepository

    // MARK: Published Properties
    @Published var eventDictionary = OrderedDictionary<Date, [Event]>()
    // TODO: Think about the data flow from API call to getting the data into the view and syncing it
    // and then displaying the data in Section views

    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
    }
}
