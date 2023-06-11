//
//  FacilityHoursView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI

struct WhatIsOpenView: View {
    let injector: Injector
    @StateObject var vm: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenViewModel())
    }

    var body: some View {
        List {
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                WhatIsOpenListView(listType: $0, parentViewModel: self.vm, injector: injector)
            }
        }
        .task {
            await vm.getData()
            // TODO: Once data is recieved it should use Combine to update the walues in the WhatIsOpenListViews
        }
    }
}

struct WhatIsOpenListView: View {
    @StateObject var vm: WhatIsOpenListViewModel

    init(listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel, injector: Injector, places: [PlaceViewModel] = []) {
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenListViewModel(places: places, listType: listType, parentViewModel: parentViewModel))
    }

    var body: some View {
        if vm.places.isEmpty {
            EmptyView()
        } else {
            Section(header: Text(vm.listType.rawValue)) {
                ForEach(vm.places) { place in
                    // TODO: Disclosure group allows you to open more than one disclosure at once. The desired behavior is that only up to one disclosure is open at any time
                    DisclosureGroup {
                        VStack {
                            HStack {
                                Text(place.note ?? "")
                                    .font(.system(.footnote))
                                    .bold()
                                Spacer()
                            }
                            Divider()
                            ForEach(0..<place.hours.count, id: \.self) { index in
                                VStack {
                                    HStack {
                                        VStack {
                                            Text(place.hours.elements[index].key)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text(place.hours.elements[index].value)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    if index != place.hours.count-1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(place.emojiCode)
                                .font(.system(size: 36))
                            VStack {
                                Text(place.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(place.isOpenString)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(place.isOpenColor)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct FacilitiesHoursView_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsOpenView(injector: Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService()))
    }
}
