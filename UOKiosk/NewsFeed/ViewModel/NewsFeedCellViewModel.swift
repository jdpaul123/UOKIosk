//
//  NewsFeedCellViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import Foundation
import SwiftUI
import Combine

class NewsFeedCellViewModel: ObservableObject {
    @Published var title: String
    @Published var thumbnailUrl: URL?
    @Published var thumbnailData: Data
    @Published var articleUrl: URL
    @Published var publishedDateString: String
    var cancellables = Set<AnyCancellable>()

    init(article: RssArticle) {
        self.title = article.title
        self.thumbnailUrl = article.imageLink
        self.thumbnailData = UIImage(resource: .no).pngData()!
        self.articleUrl = article.link

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        self.publishedDateString = dateFormatter.string(from: article.publishDate)
        getImage()
    }

    init(title: String, articleDescription: String,
         thumbnailUrl: URL, thumbnailData: Data = UIImage(resource: .no).pngData()!,
         articleUrl: URL, publishedDate: Date) {
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailData = thumbnailData
        self.articleUrl = articleUrl

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        self.publishedDateString = dateFormatter.string(from: publishedDate)
    }

    func getImage() {
        guard let thumbnailUrl = thumbnailUrl else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: thumbnailUrl)
            .sink { completion in
                // TODO: Add error handling
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("!!! Failed to get photo for news article, \(self.title), with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] (data, respose) in
                DispatchQueue.main.async {
                    self?.thumbnailData = data
                }
            }
            .store(in: &cancellables)
    }
}
