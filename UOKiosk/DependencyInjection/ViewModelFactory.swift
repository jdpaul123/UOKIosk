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
    private let whatIsOpenRepository: WhatIsOpenRepository

    // MARK: Initialization
    init(eventsRepository: EventsRepository, whatIsOpenRepository: WhatIsOpenRepository) {
        self.eventsRepository = eventsRepository
        self.whatIsOpenRepository = whatIsOpenRepository
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
        return WhatIsOpenViewModel(whatIsOpenRepository: whatIsOpenRepository)
    }
}
