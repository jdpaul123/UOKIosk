//
//  MockNewsFeedService.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 6/28/23.
//

import Foundation
@testable import UOKiosk

class MockNewsFeedService: NewsFeedRepository {
    var fetchUrl: URL = URL(string: "https://www.youtube.com")!

    func fetch(feed: URL, completion: @escaping (Result<[RssArticle], RssArticleLoadingError>) -> Void) {

    }


}
