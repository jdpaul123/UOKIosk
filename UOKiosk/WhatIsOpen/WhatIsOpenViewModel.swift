//
//  FacilityHoursViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI
import Combine
import OrderedCollections

class WhatIsOpenViewModel: ObservableObject {
    private let whatIsOpenRepository: WhatIsOpenRepository

    @Published var dining: [WhatIsOpenPlace] = []
    @Published var coffee: [WhatIsOpenPlace] = []

    // Stores
    @Published var grocery: [WhatIsOpenPlace] = []
    @Published var duckStore: [WhatIsOpenPlace] = []
    @Published var bank: [WhatIsOpenPlace] = []

    // Facilities = []
    @Published var building: [WhatIsOpenPlace] = []
    @Published var recreation: [WhatIsOpenPlace] = []
    @Published var library: [WhatIsOpenPlace] = []

    // Other = []
    @Published var other: [WhatIsOpenPlace] = []
    @Published var closed: [WhatIsOpenPlace] = [] // This list contains any closed dining, coffee, duckStores, or recreation stores/facilityies

    @Published var isLoading: Bool
    @Published var showAlert: Bool
    @Published var errorMessage: String?

    let showDining: Bool
    let showFacilities: Bool
    let showStores: Bool

    init(whatIsOpenRepository: WhatIsOpenRepository,
         showDining: Bool = false, showFacilities: Bool = false, showStores: Bool = false,
         isLoading: Bool = false, showAlert: Bool = false, errorMessage: String? = nil) {
        self.whatIsOpenRepository = whatIsOpenRepository

        self.isLoading = isLoading
        self.showAlert = showAlert
        self.errorMessage = errorMessage

        self.showDining = showDining
        self.showFacilities = showFacilities
        self.showStores = showStores
    }

    func isCategoryShown(category: WhatIsOpenCategories) -> Bool {
        return category.isCategoryShown(vm: self).contains(category)
    }

    func getData() async {
        var data: [WhatIsOpenCategories: [WhatIsOpenPlace]]?
        do {
            data = try await whatIsOpenRepository.getAssetData()
        } catch {
            // TODO: Get the error here and display it
            fatalError("Refresh of What's Open data failed")
        }
        guard let data = data else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
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
        }
    }
}

class WhatIsOpenListViewModel: ObservableObject {
    let listType: WhatIsOpenCategories
    @Published var places: [WhatIsOpenPlace]
    var cancellables = Set<AnyCancellable>()

    init(places: [WhatIsOpenPlace], listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel) {
        self.listType = listType
        self.places =  places
        listType.getWhatIsOpenViewModelData(vm: parentViewModel)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { places in
                self.places = places
            }
            .store(in: &cancellables)
    }
}

class WhatIsOpenPlaceViewModel: ObservableObject {
    let emoji: String
    let name: String
    let note: String? // Contains the building the store/facility is located in or a fun note
    let mapLink: URL?
    let WebSieLink: URL?
    let hoursIntervals: [[DateInterval]]
    @Published var isOpenString: String
    @Published var isOpenColor: Color

    var cancelables = Set<AnyCancellable>()

    // dayRangess and hoursOpen should be the same length and the nth item in each arrayu are paired up
    // Key: Each string is either one day (ex. "Monday") or a range (ex "Monday - Friday")
    // Value: Each string is either "closed", a single time range (ex. "7:00a-10:00p"), or multiple ranges split by newlines (ex. "7:00a-12:00\n1:00p-10:00p")
    let hours: OrderedDictionary<String, String>

    init(emojiCode: String, name: String, note: String?, mapLink: URL?, WebSieLink: URL?, isOpenString: String, isOpenColor: Color, hours: OrderedDictionary<String, String>, hoursIntervals: [[DateInterval]]) {
        self.emoji = emojiCode
        self.name = name
        self.note = note
        self.mapLink = mapLink
        self.WebSieLink = WebSieLink
        self.isOpenString = isOpenString
        self.isOpenColor = isOpenColor
        self.hours = hours
        self.hoursIntervals = hoursIntervals
        setUpTimer()
    }

    private func setUpTimer() {
        Timer
            .publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                var openTimes = [Date]()
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                let dayFormatter = DateFormatter()
                dayFormatter.dateStyle = .short

                for hoursIntervalArray in hoursIntervals {
                    for interval in hoursIntervalArray {
                        guard !interval.contains(.now) else {
                            isOpenColor = .green
                            isOpenString = "Open until \(timeFormatter.string(from: interval.end))"
                            return
                        }
                        openTimes.append(interval.start)
                    }
                }

                for startTime in openTimes {
                    // since the dates are in chronological order we can just find the first startTime that is after now and return that
                    guard Date.now > startTime else {
                        isOpenColor = .red

                        let cal = Calendar(identifier: .gregorian)
                        let on = cal.isDate(Date.now, inSameDayAs: startTime) ? "": "on \(startTime.dayOfWeek() ?? "")"

                        isOpenString = "Closed until \(timeFormatter.string(from: startTime)) \(on)"
                        return
                    }
                }
                isOpenColor = .red
                isOpenString = "Closed until at least Monday"
            }
            .store(in: &cancelables)
    }
}

//class FacilityHoursViewModel: ObservableObject {
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
//class StoreHoursViewModel: ObservableObject {
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
