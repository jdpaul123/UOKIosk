//
//  ViewModelFactory.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation

final class ViewModelFactory: ObservableObject {
    // MARK: Properties
    private let eventsRepository: EventsRepository
    
    // MARK: Initialization
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
    }
   
    // MARK: Make View Model Functions
    func makeEventDetailViewModel(eventModel: Event) -> EventDetailViewModel {
        EventDetailViewModel(event: eventModel)
    }
    
    func makeEventsViewModel() -> EventsViewModel {
        EventsViewModel(eventsRepository: eventsRepository)
    }

    func makeCustomizeEventsFeedViewModel() -> CustomizeEventsFeedViewModel {
        CustomizeEventsFeedViewModel()
    }

    func makeWhatIsOpenViewModel() -> WhatIsOpenViewModel {
        // TODO: Replace this with an initializer that gets data from the "WhatIsOpenRepository"
        WhatIsOpenViewModel(dining: [
                                        PlaceViewModel(name: "Test Restauraunt", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"]),
                                        PlaceViewModel(name: "Test Restauraunt 2", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"]),
                                        PlaceViewModel(name: "Test Restauraunt 3", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"]),
                                        PlaceViewModel(name: "Test Restauraunt 4", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"]),
                                        PlaceViewModel(name: "Test Restauraunt 5", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"])
                                    ],
                            coffee: [PlaceViewModel(name: "Test Coffee Shop", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"])],
                            duckStores: [PlaceViewModel(name: "Test Duck Store", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"])],
                            recreation: [PlaceViewModel(name: "Test Recreation Facility", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"])],
                            closed: [PlaceViewModel(name: "Test closed restauraunt, coffee shop, duck store, or recreation facility", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), dayRanges: ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"], hoursOpen: ["7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM", "7:00 AM-8:00 PM"])])
    }
}
