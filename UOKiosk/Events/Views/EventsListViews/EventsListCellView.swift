//
//  EventsListCellView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import SwiftUI

struct EventsListCellView: View {
    @StateObject var vm: EventsListCellViewModel

    // MARK: INITIALIZER
    init(vm: EventsListCellViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        HStack {
            vm.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipped()
            VStack(alignment: .leading) {
                Text(vm.title)
            }
        }
    }
}

//struct EventsListCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsListCellView(vm: ____)
//    }
//}
