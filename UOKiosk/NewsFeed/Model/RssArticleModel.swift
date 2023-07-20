//
//  NewsFeedArticleModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/20/23.
//

import Foundation

class RssArticle: Identifiable {
    let id = UUID()
    var title: String
    var description: String?
    var link: URL
    var imageLink: URL?
    var publishDate: Date

    init(title: String, description: String? = nil, link: URL, imageLink: URL?, publishDate: Date) {
        self.title = title
        self.description = description
        self.link = link
        self.imageLink = imageLink
        self.publishDate = publishDate
    }
}
