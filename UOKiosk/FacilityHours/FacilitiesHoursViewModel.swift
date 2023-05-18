//
//  FacilityHoursViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import Foundation

class FacilitiesHoursViewModel {
    let dining: [FacilityHoursViewModel]
    let coffee: [FacilityHoursViewModel]
    let duckStores: [FacilityHoursViewModel]
    let recreation: [FacilityHoursViewModel]
    let closed: [FacilityHoursViewModel] // This list contains any closed dining, coffee, duckStores, or recreation stores/facilityies

    init(dining: [FacilityHoursViewModel], coffee: [FacilityHoursViewModel], duckStores: [FacilityHoursViewModel], recreation: [FacilityHoursViewModel], closed: [FacilityHoursViewModel]) {
        self.dining = dining
        self.coffee = coffee
        self.duckStores = duckStores
        self.recreation = recreation
        self.closed = closed
    }
}

class FacilityHoursViewModel {
    let name: String
    let note: String? // Contains the building the store/facility is located in or a fun note
    let mapLink: URL
    let WebSieLink: URL
    // dayRangess and hoursOpen should be the same length and the nth item in each arrayu are paired up
    let dayRanges: [String] // Each string is either one day (ex. "Monday") or a range (ex "Monday - Friday")
    let hoursOpen: [String] // Each string is either "closed", a single time range (ex. "7:00a-10:00p"), or multiple ranges split by newlines (ex. "7:00a-12:00\n1:00p-10:00p")

    init(name: String, note: String? = nil, mapLink: URL, WebSieLink: URL, dayRanges: [String], hoursOpen: [String]) {
        self.name = name
        self.note = note
        self.mapLink = mapLink
        self.WebSieLink = WebSieLink
        self.dayRanges = dayRanges
        self.hoursOpen = hoursOpen
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

enum DayOfTheWeek: String {
    case Monday, Tuesday, Webnesday, Thursday, Friday, Saturday, Sunday
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
