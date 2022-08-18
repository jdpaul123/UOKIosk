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
     instantiated here and filled with cached data from Core Data. Then the repo will
     be sent to the view model factory. Any other dependencies will be created here
     too.
     */
    
    // Load data from core data.
    
    // MARK: Repositories
    public let eventsRepository: EventsRepository
    
    // MARK: View Model Factory
    public let viewModelFactory: ViewModelFactory
    
    /* MARK: Events Attributes */
    // If no data, then set the URL for events to the default: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"
    public var eventsUrlString = "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100" // TODO: make this customizable based on the filters
    
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
        viewModelFactory = ViewModelFactory(eventsRepository: eventsRepository)
    }
}
