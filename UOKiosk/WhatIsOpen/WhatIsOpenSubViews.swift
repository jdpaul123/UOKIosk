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
            HStack {
                Text(vm.building ?? "")
                    .font(.system(.footnote).weight(.bold))
                Spacer()
                if let websiteLink = vm.websiteLink {
                    Link("More Info", destination: websiteLink)
                        .font(.system(.footnote).weight(.bold ))
                        .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                        .cornerRadius(4)
                }
            }
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
                            .foregroundColor(vm.isClosedColor(closedValue: vm.hours.elements[index].value))
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
