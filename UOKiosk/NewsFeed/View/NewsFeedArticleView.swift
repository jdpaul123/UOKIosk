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
            .toolbar {
                if #available(iOS 16.0, *) {
                    ShareLink(item: articleUrl, message: Text(""))
                }
            }
    }
}

//struct NewsFeedArticle_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsFeedArticleView()
//    }
//}
