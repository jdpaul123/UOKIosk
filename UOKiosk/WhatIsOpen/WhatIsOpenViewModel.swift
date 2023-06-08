//
//  FacilityHoursViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI
import OrderedCollections

class WhatIsOpenViewModel: ObservableObject {
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
    @Published var errorMEssage: String?

    init(dining: [PlaceViewModel] = [], coffee: [PlaceViewModel] = [], duckStore: [PlaceViewModel] = [], recreation: [PlaceViewModel] = [], library: [PlaceViewModel] = [],
         closed: [PlaceViewModel] = [], grocery: [PlaceViewModel] = [], building: [PlaceViewModel] = [], bank: [PlaceViewModel] = [], other: [PlaceViewModel] = [],
         isLoading: Bool = false, showAlert: Bool = false, errorMessage: String? = nil) {
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
        self.errorMEssage = errorMessage
    }
    // FIXME: BELOW CODE IS FOR TESTING
    func refresh() async {
        var data: [WhatIsOpenCategories: [PlaceViewModel]]?
        do {
            data = try await WhatIsOpenService().getAssetData(url: "https://api.woosmap.com/stores/search/?private_key=cd319766-0df2-4135-bf2a-0a1ee3ad9a6d")
        } catch {
            fatalError("Refresh of What's Open data failed")
        }
        guard let data = data else {
            return
        }
        DispatchQueue.main.async { [self] in
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
//        self.data = try? await ApiService.shared.getJSON(urlString: "https://api.woosmap.com/stores/search/?private_key=cd319766-0df2-4135-bf2a-0a1ee3ad9a6d")
    }
}

struct PlaceViewModel: Identifiable {
    var id = UUID()
    let emojiCode: String
    let name: String
    let note: String? // Contains the building the store/facility is located in or a fun note
    let mapLink: URL?
    let WebSieLink: URL?
    let isOpenString: String
    let isOpenColor: Color

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


class FacilityHours {
    let name: String
    let mapLink: URL
    let WebSiteLink : URL

    let hoursOfOperations: [HoursOfOperation] // There is always 7 items in this array starting with Monday as index 0 to Sunday at index 6

    init(name: String, mapLink: URL, WebSiteLink: URL, hoursOfOperations: [HoursOfOperation]) {
        self.name = name
        self.mapLink = mapLink
        self.WebSiteLink = WebSiteLink
        self.hoursOfOperations = hoursOfOperations
    }
}

class HoursOfOperation {
    let day: DayOfTheWeek
    let isCloasedToday: Bool
    let hours: [TimeRange] // Empty if closed, otherwise there should be at least one TimeRange

    init(day: DayOfTheWeek, isCloasedToday: Bool, hours: [TimeRange]) {
        self.day = day
        self.isCloasedToday = isCloasedToday
        self.hours = hours
    }
}

class TimeRange {
    // startTime and endTIme are both represented as seconds since midnight. So 2:00 PM would be 50400, while 12:02 AM is 120.
    let startTime: Int
    let endTime: Int

    init(startTime: Int, endTime: Int) {
        self.startTime = startTime
        self.endTime = endTime
    }
}
