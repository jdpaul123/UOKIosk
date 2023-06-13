//
//  WhatIsOpenDto.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/6/23.
//

import Foundation

struct WhatIsOpenDto: Decodable {
    let type: String
    let pagination: WhatIsOpenPaginationDto
    let features: [StoreDto]
}

struct StoreDto: Decodable {
    let type: String
    let properties: StorePropertiesDto
}

struct StorePropertiesDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "store_id"
        case name = "name"
        case contact = "contact"
        case hours = "weekly_opening"
        case types = "types"
        case open = "open"
        case userProperties = "user_properties"
    }
    let id: String
    let name: String
    let contact: StoreContactDto?
    let hours: WeeklyStoreScheduleDto
    let types: [String] // "Dining" "Coffee" "Duck Store" "Recreation" "Library" (note: There is also closed. Anything that is closed should go in that bucket.)
    let open: CurrentStoreStatusDto
    let userProperties: UserPropertiesDto
}

struct UserPropertiesDto: Decodable {
    let emoji: String?
    let building: String?
}

struct CurrentStoreStatusDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case isOpen = "open_now"
        case openHours = "open_hours"
        case today = "week_day"
        case nextOpening = "next_opening"
        case currentSlice = "current_slice"
    }
    let isOpen: Bool
    let openHours: [OpenHoursIntervalDto]
    let today: Int
    // The object will have either a nextOpening if the store is closed or a currentSlice for the current time the store is open
    let nextOpening: NextOpeningDto?
    let currentSlice: OpenHoursIntervalDto?
}

struct NextOpeningDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case start = "start"
        case end = "end"
        case dateString = "day"
    }
    let start: String
    let end: String
    let dateString: String
}

struct WeeklyStoreScheduleDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case timezone = "timezone"
        case monday = "1"
        case tuesday = "2"
        case wednsday = "3"
        case thursday = "4"
        case friday = "5"
        case saturday = "6"
        case sunday = "7"

    }
    let timezone: String
    let monday: StoreDayScheduleDto
    let tuesday: StoreDayScheduleDto
    let wednsday: StoreDayScheduleDto
    let thursday: StoreDayScheduleDto
    let friday: StoreDayScheduleDto
    let saturday: StoreDayScheduleDto
    let sunday: StoreDayScheduleDto
}

struct StoreDayScheduleDto: Decodable {
    let hours: [OpenHoursIntervalDto]
    let isSpecial: Bool
}

struct OpenHoursIntervalDto: Decodable {
    let start: String
    let end: String
}

struct StoreContactDto: Decodable {
    let phone: String?
    let website: String?
}

struct WhatIsOpenPaginationDto: Decodable {
    let page: Int
    let pageCount: Int
}
