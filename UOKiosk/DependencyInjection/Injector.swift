//
//  Injector.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation

final class Injector: ObservableObject {
    /*
     This class will create any dependencies. So the repository will be
     instantiated here and filled with cached data from a Core Data Persistent Store.
     Then the repo is sent to the view model factory. Any other dependencies
     are created here too.
     */
    // MARK: REST API URLs
    var eventsUrlString = "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100" // TODO: make this customizable based on the filters
    var whatIsOpenUrlString = "https://api.woosmap.com/stores/search/?private_key=cd319766-0df2-4135-bf2a-0a1ee3ad9a6d"
    var newsFeedUrl = URL(string: "https://www.dailyemerald.com/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc")!

    // MARK: - Repositories
    let eventsRepository: EventsRepository
    private let whatIsOpenRepository: WhatIsOpenRepository
    let newsFeedRepository: NewsFeedRepository

    // MARK: - View Model Factory
    public let viewModelFactory: ViewModelFactory

    // MARK: - Initialization
    init(eventsRepository: EventsRepository, whatIsOpenRepository: WhatIsOpenRepository,
         newsFeedRepository: NewsFeedRepository) {
        self.eventsRepository = eventsRepository
        self.whatIsOpenRepository = whatIsOpenRepository
        self.newsFeedRepository = newsFeedRepository
        viewModelFactory = ViewModelFactory(eventsRepository: self.eventsRepository,
                                            whatIsOpenRepository: self.whatIsOpenRepository,
                                            newsFeedRepository: self.newsFeedRepository)

    }

    init() {
        self.eventsRepository = EventsService(urlString: eventsUrlString)
        self.whatIsOpenRepository = WhatIsOpenService(urlString: whatIsOpenUrlString)
        self.newsFeedRepository = NewsFeedService(fetchUrl: newsFeedUrl)
        viewModelFactory = ViewModelFactory(eventsRepository: self.eventsRepository,
                                            whatIsOpenRepository: self.whatIsOpenRepository,
                                            newsFeedRepository: self.newsFeedRepository)

        // TODO: Delete this - it is for testing the RSSFeedService fetch request
//        let rssFeedService = NewsFeedService(fetchUrl: newsFeedUrl)
//        rssFeedService.fetch(feed: newsFeedUrl) { result in
//            switch result {
//            case .success(let articles):
//                for article in articles {
//                    print(article.title)
//                    print(article.description ?? "NO DESCRIPTION")
//                    print(article.link)
//                    print(article.imageLink ?? "NO IMAGE LINK")
//                    print(article.publishDate)
//                    print()
//                }
//            case .failure(let error):
//                print("!!! FAILED TO FETCH RSS FEED DATA")
//                print(error.localizedDescription)
//            }
//        }
    }
}
