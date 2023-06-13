//
//  FacilityHoursView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI

protocol WhatIsOpenView: View {

}

struct DiningHoursView: WhatIsOpenView {
    let injector: Injector
    @StateObject var vm: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenViewModel(type: .dining))
    }

    var body: some View {
        List {
            NavigationLink(destination: FacilityHoursView(injector: injector, whatIsOpenViewModel: vm).navigationTitle("What's Open: Facility Hours")) {
                Text("Facilities Hours")
            }
            NavigationLink(destination: StoreHoursView(injector: injector, whatIsOpenViewModel: vm).navigationTitle("What's Open: Store Hours")) {
                Text("Stores Hours")
            }
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                if vm.isCategoryShown(category: $0) {
                    WhatIsOpenListView(listType: $0, parentViewModel: self.vm, injector: injector)
                }
            }
        }
        .task {
            await vm.getData()
            // TODO: Once data is recieved it should use Combine to update the walues in the WhatIsOpenListViews
        }
    }
}

struct FacilityHoursView: WhatIsOpenView {
    let injector: Injector
    @StateObject var vm: WhatIsOpenViewModel
    let whatIsOpenViewModel: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(injector: Injector, whatIsOpenViewModel: WhatIsOpenViewModel) {
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenViewModel(type: .facilities))
        self.injector = injector
        self.whatIsOpenViewModel = whatIsOpenViewModel
    }

    var body: some View {
        List {
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                if vm.isCategoryShown(category: $0) {
                    WhatIsOpenListView(listType: $0, parentViewModel: whatIsOpenViewModel, injector: injector)
                }
            }
        }
    }
}

struct StoreHoursView: WhatIsOpenView {
    let injector: Injector
    @StateObject var vm: WhatIsOpenViewModel
    let whatIsOpenViewModel: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(injector: Injector, whatIsOpenViewModel: WhatIsOpenViewModel) {
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenViewModel(type: .stores))
        self.injector = injector
        self.whatIsOpenViewModel = whatIsOpenViewModel
    }

    var body: some View {
        List {
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                if vm.isCategoryShown(category: $0) {
                    WhatIsOpenListView(listType: $0, parentViewModel: whatIsOpenViewModel, injector: injector)
                }
            }
        }
    }
}


struct WhatIsOpenView_Previews: PreviewProvider {
    static var previews: some View {
        DiningHoursView(injector: Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService()))
    }
}
