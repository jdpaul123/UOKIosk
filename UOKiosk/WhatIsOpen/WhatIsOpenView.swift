//
//  FacilityHoursView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI

enum WhatIsOpenListCase: String {
    case dining, coffee, recreation, closed
    case duckStores = "Duck Stores"
}

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
            WhatIsOpenList(listType: .dining, vm: vm)
            WhatIsOpenList(listType: .coffee, vm: vm)
            WhatIsOpenList(listType: .recreation, vm: vm)
            WhatIsOpenList(listType: .duckStores, vm: vm)
            WhatIsOpenList(listType: .closed, vm: vm)
        }
    }
}

struct WhatIsOpenList: View {
    let listType: WhatIsOpenListCase
    @ObservedObject var vm: WhatIsOpenViewModel

    var listOfPlace: Binding<[PlaceViewModel]> {
        switch listType {
        case .dining:
            return $vm.dining
        case .coffee:
            return $vm.coffee
        case .duckStores:
            return $vm.duckStores
        case .recreation:
            return $vm.recreation
        case .closed:
            return $vm.closed
        }
    }

    var body: some View {
        Section(header: Text(listType.rawValue)) {
            ForEach(listOfPlace) { $place in
                DisclosureGroup {
                    VStack {
                        HStack {
                            Text(place.note ?? "")
                            Spacer()
                        }
                    }
                } label: {
                    Text(place.name)
                }
            }
        }
    }
}

struct FacilitiesHoursView_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsOpenView(injector: Injector(eventsRepository: MockEventsService()))
    }
}
