//
//  ViewModelFactory.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation
import OrderedCollections

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
        return WhatIsOpenViewModel(dining: [], coffee: [], duckStore: [], recreation: [], library: [], closed: [])
        // TODO: Replace this with an initializer that gets data from the "WhatIsOpenRepository"
//        let hours: OrderedDictionary<String, String> = [
//            "Monday": "7:00a - 12:00p\n1:00a - 8:00p",
//            "Tuesday": "7:00a -8:00p ",
//            "Wednsday": "7:00a - 8:00p",
//            "Thursday": "7:00a - 8:00p",
//            "Friday": "7:00a - 8:00p",
//            "Saturday": "7:00a - 8:00p",
//            "Sunday": "7:00a - 8:00p"
//        ]
//        return WhatIsOpenViewModel(dining: [
//                                        PlaceViewModel(name: "Test Restauraunt 0", emojiCode: "🍔", note: "Test Dorm", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours),
//                                        PlaceViewModel(name: "Test Restauraunt 2", emojiCode: "🍕", note: "Test Union", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours),
//                                        PlaceViewModel(name: "Test Restauraunt 3", emojiCode: "🍣", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours),
//                                        PlaceViewModel(name: "Test Restauraunt 4", emojiCode: "🥪", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours),
//                                        PlaceViewModel(name: "Test Restauraunt 5", emojiCode: "🛒", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours)
//                                    ],
//                            coffee: [PlaceViewModel(name: "Test Coffee Shop", emojiCode: "☕", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours)],
//                            duckStore: [PlaceViewModel(name: "Test Duck Store", emojiCode: "🦆", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours)],
//                            recreation: [PlaceViewModel(name: "Test Recreation Facility", emojiCode: "💪", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: true, hours: hours)],
//                            library: [],
//                            closed: [PlaceViewModel(name: "Test closed restauraunt, coffee shop, duck store, or recreation facility", emojiCode: "🍕", mapLink: URL(string: "www.google.com")!, WebSieLink: URL(string: "www.youtube.com")!, until: Date.init(timeIntervalSinceNow: 3600), isOpen: false, hours: hours)])
    }
}
