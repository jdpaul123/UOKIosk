//
//  NewsFeedArticleView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/28/23.
//

import SwiftUI

struct NewsFeedArticleView: View {
    let articleUrl: URL

    var body: some View {
        NewsFeedArticleWebViewRepresentable(url: articleUrl)
            .navigationBarTitleDisplayMode(.inline)
    }
}

//struct NewsFeedArticle_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsFeedArticleView()
//    }
//}
