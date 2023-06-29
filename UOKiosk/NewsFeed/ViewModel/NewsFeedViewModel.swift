//
//  NewsFeedViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import Foundation

class NewsFeedViewModel: ObservableObject {
    let newsFeedRepository: NewsFeedRepository
    @Published var articles: [RssArticle] = []
    @Published var showingInformationSheet: Bool = false

    init(newsFeedRepository: NewsFeedRepository) {
        self.newsFeedRepository = newsFeedRepository
    }

    func fetchArticles() {
        newsFeedRepository.fetch(feed: newsFeedRepository.fetchUrl) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
            case .failure(let error):
                print(error)
            }
        }
    }
}
