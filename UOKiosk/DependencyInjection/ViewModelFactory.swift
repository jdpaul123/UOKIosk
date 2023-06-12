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
    func makeEventsViewModel() -> EventsViewModel {
        EventsViewModel(eventsRepository: eventsRepository)
    }

    func makeEventDetailViewModel(eventModel: Event) -> EventDetailViewModel {
        EventDetailViewModel(event: eventModel)
    }

    func makeCustomizeEventsFeedViewModel() -> CustomizeEventsFeedViewModel {
        CustomizeEventsFeedViewModel()
    }

    func makeWhatIsOpenViewModel() -> WhatIsOpenViewModel {
        WhatIsOpenViewModel(whatIsOpenRepository: whatIsOpenRepository)
    }

    func makeWhatIsOpenListViewModel(places: [WhatIsOpenPlace], listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel) -> WhatIsOpenListViewModel {
        WhatIsOpenListViewModel(places: places, listType: listType, parentViewModel: parentViewModel)
    }

    func makeWhatIsOpenPlaceViewModel(place: WhatIsOpenPlace) -> WhatIsOpenPlaceViewModel {
        WhatIsOpenPlaceViewModel(emojiCode: place.emoji, name: place.name, note: place.note, mapLink: place.mapLink, WebSieLink: place.WebSieLink, isOpenString: place.isOpenString, isOpenColor: place.isOpenColor, hours: place.hours)
    }
}
