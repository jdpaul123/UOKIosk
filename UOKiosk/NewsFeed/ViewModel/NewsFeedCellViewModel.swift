//
//  NewsFeedCellViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import Foundation
import SwiftUI

class NewsFeedCellViewModel: ObservableObject {
    @Published var title: String
    @Published var articleDescription: String
    @Published var thumbnailUrl: URL
    @Published var thumbnailData: Data
    @Published var articleUrl: URL
    @Published var publishedDateString: String

    init(title: String, articleDescription: String,
         thumbnailUrl: URL, thumbnailData: Data = UIImage(named: "NoImage")!.pngData()!,
         articleUrl: URL, publishedDate: Date) {
        self.title = title
        self.articleDescription = articleDescription
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailData = thumbnailData
        self.articleUrl = articleUrl

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        self.publishedDateString = dateFormatter.string(from: publishedDate)
    }
}
