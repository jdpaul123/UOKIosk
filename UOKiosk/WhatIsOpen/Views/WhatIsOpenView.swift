//
//  WhatIsOpenView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI

protocol WhatIsOpenView: View {

}

struct DiningHoursView: WhatIsOpenView {
    @EnvironmentObject var injector: Injector
    @State var showingInformationSheet = false
    @StateObject var vm: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(vm: WhatIsOpenViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            NavigationLink(destination: FacilityHoursView(vm: injector.viewModelFactory.makeWhatIsOpenViewModel(type: .facilities))
                .environmentObject(vm)
                .navigationTitle("Facility Hours")) {
                Text("Facility Hours")
            }
            NavigationLink(destination: StoreHoursView(vm: injector.viewModelFactory.makeWhatIsOpenViewModel(type: .stores))
                .environmentObject(vm)
                .navigationTitle("Store Hours")) {
                Text("Store Hours")
            }
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                if vm.isCategoryShown(category: $0) {
                    WhatIsOpenListView(vm: injector.viewModelFactory.makeWhatIsOpenListViewModel(places: [], listType: $0, parentViewModel: vm))
                        .environmentObject(vm)
                }
            }
        }
        .overlay {
            if vm.showLoading {
                ProgressView()
                    .scaleEffect(2)
            }
        }
        .task {
            if !vm.viewHasLoaded {
                await vm.getData()
            }
        }
        .banner(data: $vm.bannerData, show: $vm.showBanner)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingInformationSheet.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showingInformationSheet) { InformationView() }
    }
}

struct FacilityHoursView: WhatIsOpenView {
    @EnvironmentObject var injector: Injector
    @EnvironmentObject var diningHoursViewModel: WhatIsOpenViewModel
    @StateObject var vm: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(vm: WhatIsOpenViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                if vm.isCategoryShown(category: $0) {
                    WhatIsOpenListView(vm: injector.viewModelFactory.makeWhatIsOpenListViewModel(places: [], listType: $0, parentViewModel: diningHoursViewModel))
                }
            }
        }
    }
}

struct StoreHoursView: WhatIsOpenView {
    @EnvironmentObject var injector: Injector
    @EnvironmentObject var diningHoursViewModel: WhatIsOpenViewModel
    @StateObject var vm: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(vm: WhatIsOpenViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            ForEach(WhatIsOpenCategories.allCases, id: \.rawValue) {
                if vm.isCategoryShown(category: $0) {
                    WhatIsOpenListView(vm: injector.viewModelFactory.makeWhatIsOpenListViewModel(places: [], listType: $0, parentViewModel: diningHoursViewModel))
                }
            }
        }
    }
}


//struct WhatIsOpenView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiningHoursView(injector: Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService()))
//    }
//}
