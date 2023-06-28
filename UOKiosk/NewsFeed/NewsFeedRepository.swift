//
//  NewsFeedRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/28/23.
//

import Foundation

protocol NewsFeedRepository {
    var fetchUrl: URL  { get }

    func fetch(feed: URL, completion: @escaping (Swift.Result<[RssArticle], RssArticleLoadingError>) -> Void)
}
