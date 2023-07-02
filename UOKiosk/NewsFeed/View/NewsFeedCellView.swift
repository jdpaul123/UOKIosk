//
//  NewsFeedViewCell.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import SwiftUI

struct NewsFeedCellView: View {
    @StateObject var vm: NewsFeedCellViewModel

    init(vm: NewsFeedCellViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: vm.thumbnailData)!)
                .resizable()
                .aspectRatio(UIImage(data: vm.thumbnailData)!.size, contentMode: .fill)
                .frame(width: 132, height: 132)
                .clipped()
            VStack(alignment: .leading) {
                Text(vm.title)
                    .font(.headline.weight(.bold))
                Text(vm.publishedDateString)
                    .font(.subheadline)
            }
        }
        .frame(height: 110)
    }
}

struct NewsFeed_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NewsFeedCellView(vm: NewsFeedCellViewModel(title: "Text Title", articleDescription: "Test Description",
                                                       thumbnailUrl: URL(string: "https://bloximages.newyork1.vip.townnews.com/dailyemerald.com/content/tncms/assets/v3/editorial/8/93/893e0730-0e30-11ee-9ae3-db7ac2dbc3eb/648f944bd8472.image.png?resize=300%2C206")!,
                                                       articleUrl: URL(string: "https://www.dailyemerald.com/news/family-of-uo-hockey-player-plans-to-file-wrongful-death-suit/article_a55288f2-0e2f-11ee-83eb-5bd74b049858.html")!,
                                                       publishedDate: Date()))
        }
        .listStyle(.plain)
        .previewLayout(.fixed(width: 400, height: 80))
    }
}
