//
//  NewsFeedView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject var vm: NewsFeedViewModel

    init(vm: NewsFeedViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            
        }
    }
}

//struct NewsFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsFeedView(vm: NewsFeedViewModel())
//    }
//}
