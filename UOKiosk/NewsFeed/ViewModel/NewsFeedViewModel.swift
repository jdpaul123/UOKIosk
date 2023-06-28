//
//  NewsFeedViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import Foundation

class NewsFeedViewModel: ObservableObject {
    @Published var articles: [RssArticle]

    init(articles: [RssArticle]) {
        self.articles = articles
    }
}
