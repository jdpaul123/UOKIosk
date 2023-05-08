//
//  Injector.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation

final class Injector: ObservableObject {
    /*
     This calss will create any dependencies. So the repository will be
     instantiated here and filled with cached data from a Core Data Persistent Store.
     Then the repo is sent to the view model factory. Any other dependencies
     are created here too.
     */
    // MARK: - Repositories
    public let eventsRepository: EventsRepository

    // MARK: - View Model Factory
    public let viewModelFactory: ViewModelFactory

    // MARK: - Events Attributes
    // If no data, then set the URL for events to the default: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"
    public var eventsUrlString = "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100" // TODO: make this customizable based on the filters

    // MARK: - Initialization
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
        viewModelFactory = ViewModelFactory(eventsRepository: eventsRepository)
    }
}
