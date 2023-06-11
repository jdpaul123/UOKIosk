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

    @Published var dining: [PlaceViewModel]
    @Published var coffee: [PlaceViewModel]
    @Published var duckStore: [PlaceViewModel]
    @Published var recreation: [PlaceViewModel]
    @Published var library: [PlaceViewModel]
    @Published var grocery: [PlaceViewModel]
    @Published var building: [PlaceViewModel]
    @Published var bank: [PlaceViewModel]
    @Published var other: [PlaceViewModel]
    @Published var closed: [PlaceViewModel] // This list contains any closed dining, coffee, duckStores, or recreation stores/facilityies

    @Published var isLoading: Bool
    @Published var showAlert: Bool
    @Published var errorMessage: String?

    init(whatIsOpenRepository: WhatIsOpenRepository,
         dining: [PlaceViewModel] = [], coffee: [PlaceViewModel] = [], duckStore: [PlaceViewModel] = [], recreation: [PlaceViewModel] = [], library: [PlaceViewModel] = [],
         closed: [PlaceViewModel] = [], grocery: [PlaceViewModel] = [], building: [PlaceViewModel] = [], bank: [PlaceViewModel] = [], other: [PlaceViewModel] = [],
         isLoading: Bool = false, showAlert: Bool = false, errorMessage: String? = nil) {
        self.whatIsOpenRepository = whatIsOpenRepository

        self.dining = dining
        self.coffee = coffee
        self.duckStore = duckStore
        self.recreation = recreation
        self.library = library
        self.closed = closed
        self.grocery = grocery
        self.building = building
        self.bank = bank
        self.other = other

        self.isLoading = isLoading
        self.showAlert = showAlert
        self.errorMessage = errorMessage
    }

    func getData() async {
        var data: [WhatIsOpenCategories: [PlaceViewModel]]?
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
            dining = data[.dining]!
            coffee = data[.coffee]!
            duckStore = data[.duckStore]!
            recreation = data[.recreation]!
            library = data[.library]!
            bank = data[.bank]!
            grocery = data[.grocery]!
            building = data[.building]!
            other = data[.other]!
            closed = data[.closed]!
        }
    }
}

class WhatIsOpenListViewModel: ObservableObject {
    let listType: WhatIsOpenCategories
    @Published var places: [PlaceViewModel]
    var cancellables = Set<AnyCancellable>()

    init(places: [PlaceViewModel], listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel) {
        self.listType = listType
        self.places =  places
        listType.getWhatIsOpenViewModelData(vm: parentViewModel).sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        } receiveValue: { placeViewModels in
            self.places = placeViewModels
        }
        .store(in: &cancellables)

    }
}

class PlaceViewModel: Identifiable {
    var id = UUID()
    let emojiCode: String
    let name: String
    let note: String? // Contains the building the store/facility is located in or a fun note
    let mapLink: URL?
    let WebSieLink: URL?
    @Published var isOpenString: String
    @Published var isOpenColor: Color

    // dayRangess and hoursOpen should be the same length and the nth item in each arrayu are paired up
    // Key: Each string is either one day (ex. "Monday") or a range (ex "Monday - Friday")
    // Value: Each string is either "closed", a single time range (ex. "7:00a-10:00p"), or multiple ranges split by newlines (ex. "7:00a-12:00\n1:00p-10:00p")
    let hours: OrderedDictionary<String, String>

    // For the Until: Date value: If open, then this value is used as an indicator of when the place closes next. If closed, then this value is used as an indicator of when the place opens next
    init(name: String, emojiCode: String, note: String? = nil, mapLink: URL?, WebSieLink: URL?, until: Date, isOpen: Bool, hours: OrderedDictionary<String, String>) {
        self.name = name
        self.emojiCode = emojiCode
        self.note = note
        self.mapLink = mapLink
        self.WebSieLink = WebSieLink
        self.hours = hours
        self.isOpenColor = isOpen ? .green: .red
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.isOpenString = "\(isOpen ? "Open": "Closed") until \(formatter.string(from: until))"
    }
}
