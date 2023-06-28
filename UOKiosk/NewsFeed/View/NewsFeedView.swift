//
//  NewsFeedView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import SwiftUI

struct NewsFeedView: View {
    @EnvironmentObject var injector: Injector
    @StateObject var vm: NewsFeedViewModel

    init(vm: NewsFeedViewModel) {
        _vm = StateObject(wrappedValue: vm)

        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
    }

    let dateFormatter: DateFormatter

    var body: some View {
        List {
            ForEach(vm.articles.sorted(by: { $0.publishDate > $1.publishDate }), id: \.id) { article in
                NavigationLink {
                    NewsFeedArticleView(articleUrl: article.link)
                } label: {
                    NewsFeedCellView(vm: injector.viewModelFactory.makeNewsFeedCellViewModel(article: article))
                }
            }
        }
        .onAppear {
            vm.fetchArticles()
        }
    }
}
//struct NewsFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsFeedView(vm: NewsFeedViewModel())
//    }
//}
