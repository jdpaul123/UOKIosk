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
    func makeEventsListViewModel() -> EventsListViewModel {
        EventsListViewModel(eventsRepository: eventsRepository)
    }

    func makeEventsListSectionViewModel(parentViewModel: EventsListViewModel, dateToDisplay: Date) -> EventsListSectionViewModel {
        EventsListSectionViewModel(parentViewModel: parentViewModel, dateToDisplay: dateToDisplay)
    }

    func makeEventsListCellViewModel(event: Event) -> EventsListCellViewModel {
        EventsListCellViewModel(event: event)
    }

    func makeEventDetailViewModel(eventModel: Event) -> EventDetailViewModel {
        EventDetailViewModel(event: eventModel)
    }

    func makeWhatIsOpenViewModel(type: WhatIsOpenViewType) -> WhatIsOpenViewModel {
        WhatIsOpenViewModel(whatIsOpenRepository: whatIsOpenRepository, showDining: type == .dining,
                            showFacilities: type == .facilities, showStores: type == .stores)
    }

    func makeWhatIsOpenListViewModel(places: [WhatIsOpenPlace], listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel) -> WhatIsOpenListViewModel {
        WhatIsOpenListViewModel(places: places, listType: listType, parentViewModel: parentViewModel)
    }

    func makeWhatIsOpenPlaceViewModel(place: WhatIsOpenPlace) -> WhatIsOpenPlaceViewModel {
        WhatIsOpenPlaceViewModel(emojiCode: place.emoji, name: place.name, building: place.building, mapLink: place.mapLink, websiteLink: place.websiteLink,
                                 isOpenString: place.isOpenString, isOpenColor: place.isOpenColor, until: place.until, hours: place.hours, hoursIntervals: place.hoursIntervals)
    }

    func makeNewsFeedViewModel(articles: [RssArticle]) -> NewsFeedViewModel {
        NewsFeedViewModel(articles: articles)
    }

    func makeNewsFeedCellViewModel(title: String, articleDescription: String, thumbnailUrl: URL, articleUrl: URL, publishedDate: Date) -> NewsFeedCellViewModel {
        NewsFeedCellViewModel(title: title, articleDescription: articleDescription, thumbnailUrl: thumbnailUrl,
                              articleUrl: articleUrl, publishedDate: publishedDate)
    }
}
