//
//  WhatIsOpenSubviews.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/12/23.
//

import SwiftUI

struct WhatIsOpenListView: View {
    let injector: Injector
    @StateObject var vm: WhatIsOpenListViewModel

    init(listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel, injector: Injector, places: [WhatIsOpenPlace] = []) {
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenListViewModel(places: places, listType: listType, parentViewModel: parentViewModel))
        self.injector = injector
    }

    var body: some View {
        if vm.places.isEmpty {
            EmptyView()
        } else {
            Section(header: Text(vm.listType.rawValue)) {
                ForEach(vm.places) { place in
                    // TODO: Disclosure group allows you to open more than one disclosure at once. The desired behavior is that only up to one disclosure is open at any time
                    WhatIsOpenPlaceView(whatIsOpenPlace: place, injector: injector)
                }
            }
        }
    }
}

struct WhatIsOpenPlaceView: View {
    @StateObject var vm: WhatIsOpenPlaceViewModel
    let injector: Injector

    init(whatIsOpenPlace: WhatIsOpenPlace, injector: Injector) {
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenPlaceViewModel(place: whatIsOpenPlace))
        self.injector = injector
    }

    var body: some View {
        DisclosureGroup {
            VStack {
                HStack {
                    Text(vm.note ?? "")
                        .font(.system(.footnote))
                        .bold()
                    Spacer()
                }
                Divider()
                ForEach(0..<vm.hours.count, id: \.self) { index in
                    VStack {
                        HStack {
                            VStack {
                                Text(vm.hours.elements[index].key)
                                Spacer()
                            }
                            Spacer()
                            Text(vm.hours.elements[index].value)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if index != vm.hours.count-1 {
                            Divider()
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(vm.emoji)
                    .font(.system(size: 36))
                VStack {
                    Text(vm.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(vm.isOpenString)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(vm.isOpenColor)
                }
            }
        }
    }
}
