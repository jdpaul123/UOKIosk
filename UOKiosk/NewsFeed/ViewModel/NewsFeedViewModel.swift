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
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)
    @Published var showLoading: Bool = false

    init(newsFeedRepository: NewsFeedRepository) {
        self.newsFeedRepository = newsFeedRepository
    }

    func fetchArticles() {
        showLoading = true
        newsFeedRepository.fetch(feed: newsFeedRepository.fetchUrl) { [weak self] result in
            guard let self = self else { return }
            defer { self.showLoading = false }
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                bannerData.title = "Error"
                bannerData.detail = error.localizedDescription
                showBanner = true
                print(error)
            }
        }
    }
}
