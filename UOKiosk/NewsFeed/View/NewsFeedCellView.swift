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
            VStack {
                Text(vm.title)
            }
        }
    }
}
