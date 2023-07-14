//
//  FacilityHoursViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI
import Combine
import OrderedCollections

protocol WhatIsOpenViewModelType: ObservableObject {

}

class WhatIsOpenViewModel: WhatIsOpenViewModelType {
    private let whatIsOpenRepository: WhatIsOpenRepository

    @Published var showingInformationSheet: Bool = false
    @Published var showingIssueReportingSheet: Bool = false

    @Published var dining: [WhatIsOpenPlace] = []
    @Published var coffee: [WhatIsOpenPlace] = []

    // Stores
    @Published var grocery: [WhatIsOpenPlace] = []
    @Published var duckStore: [WhatIsOpenPlace] = []
    @Published var bank: [WhatIsOpenPlace] = []

    // Facilities
    @Published var building: [WhatIsOpenPlace] = []
    @Published var recreation: [WhatIsOpenPlace] = []
    @Published var library: [WhatIsOpenPlace] = []

    // Other
    @Published var other: [WhatIsOpenPlace] = []
    @Published var closed: [WhatIsOpenPlace] = [] // This list contains any closed dining, coffee, duckStores, or recreation stores/facilityies

    // Loading
    @Published var viewHasLoaded = false
    @Published private var isLoading: Bool
    var showLoading: Bool {
        if isLoading, isDataEmpty() {
            return true
        }
        return false
    }

    // Error Handling
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)

    let showDining: Bool
    let showFacilities: Bool
    let showStores: Bool

    init(whatIsOpenRepository: WhatIsOpenRepository,
         showDining: Bool = false, showFacilities: Bool = false, showStores: Bool = false,
         isLoading: Bool = false, showAlert: Bool = false, errorMessage: String? = nil) {
        self.whatIsOpenRepository = whatIsOpenRepository

        self.isLoading = isLoading

        self.showDining = showDining
        self.showFacilities = showFacilities
        self.showStores = showStores
    }

    func isCategoryShown(category: WhatIsOpenCategories) -> Bool {
        return category.isCategoryShown(vm: self).contains(category)
    }

    @MainActor
    func getData() async {
        isLoading = true
        defer { isLoading = false }
        var data: [WhatIsOpenCategories: [WhatIsOpenPlace]]?
        do {
            data = try await whatIsOpenRepository.getAssetData()
        } catch {
            bannerData.title = "Error"
            bannerData.detail = error.localizedDescription
            showBanner = true
            return
        }
        guard let data = data else {
            return
        }

        // Note: The default empty array ([]) should never be set
        dining = data[.dining] ?? []
        coffee = data[.coffee] ?? []
        duckStore = data[.duckStore] ?? []
        recreation = data[.recreation] ?? []
        library = data[.library] ?? []
        bank = data[.bank] ?? []
        grocery = data[.grocery] ?? []
        building = data[.building] ?? []
        other = data[.other] ?? []
        closed = data[.closed] ?? []
        viewHasLoaded = true
    }

    private func isDataEmpty() -> Bool {
        if dining.isEmpty, coffee.isEmpty, duckStore.isEmpty, recreation.isEmpty, library.isEmpty,
            bank.isEmpty, grocery.isEmpty, building.isEmpty, other.isEmpty, closed.isEmpty {
            return true
        }
        return false
    }
}

//class FacilityHoursViewModel: WhatIsOpenViewModelType {
//    let whatIsOpenViewModel: WhatIsOpenViewModel
//
//    init(whatIsOpenViewModel: WhatIsOpenViewModel) {
//        self.whatIsOpenViewModel = whatIsOpenViewModel
//    }
//
//    func isCategoryShown(category: WhatIsOpenCategories) -> Bool {
//        if category == .building || category == .recreation || category == .library {
//            return true
//        }
//        return false
//    }
//}
//
//class StoreHoursViewModel: WhatIsOpenViewModelType {
//    let whatIsOpenViewModel: WhatIsOpenViewModel
//
//    init(whatIsOpenViewModel: WhatIsOpenViewModel) {
//        self.whatIsOpenViewModel = whatIsOpenViewModel
//    }
//
//    func isCategoryShown(category: WhatIsOpenCategories) -> Bool {
//        if category == .grocery || category == .duckStore || category == .bank {
//            return true
//        }
//        return false
//    }
//}
