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
    // MARK: REST API URLs
    // FIXME: This url does not show recurring events. Add an option for allowing recurring events in a settings page on the app
    // If no data, then set the URL for events to the default: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"
    var eventsUrlString = "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100" // TODO: make this customizable based on the filters
    var whatIsOpenUrlString = "https://api.woosmap.com/stores/search/?private_key=cd319766-0df2-4135-bf2a-0a1ee3ad9a6d"

    // MARK: - Repositories
    let eventsRepository: EventsRepository
    private let whatIsOpenRepository: WhatIsOpenRepository

    // MARK: - View Model Factory
    public let viewModelFactory: ViewModelFactory

    // MARK: - Initialization
    init(eventsRepository: EventsRepository = EventsService(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"),
         whatIsOpenRepository: WhatIsOpenRepository = WhatIsOpenService(urlString: "https://api.woosmap.com/stores/search/?private_key=cd319766-0df2-4135-bf2a-0a1ee3ad9a6d")) {
        self.eventsRepository = eventsRepository
        self.whatIsOpenRepository = whatIsOpenRepository
        viewModelFactory = ViewModelFactory(eventsRepository: eventsRepository, whatIsOpenRepository: whatIsOpenRepository)

        // TODO: Delete this - it is for testing the RSSFeedService fetch request
//        let rssFeedService = RSSFeedService()
//        rssFeedService.fetch(feed: RSSFeedService.feedUrl) { result in
//            switch result {
//            case .success(let articles):
//                for article in articles {
//                    print(article.title ?? "NO TITLE")
//                    print(article.description ?? "NO DESCRIPTION")
//                    print(article.link ?? "NO LINK")
//                    print()
//                }
//            case .failure(let error):
//                print("!!! FAILED TO FETCH RSS FEED DATA")
//                print(error.localizedDescription)
//            }
//        }
    }
}
