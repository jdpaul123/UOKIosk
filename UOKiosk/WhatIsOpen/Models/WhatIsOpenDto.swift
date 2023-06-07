//
//  File.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/6/23.
//

import Foundation

struct WhatIsOpenDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case pagination = "pagination"
        case features = "features"
    }
    let type: String
    let pagination: WhatIsOpenPaginationDto
    let features: [StoreDto]
}

struct StoreDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case properties = "properties"
    }
    let type: String
    let properties: StorePropertiesDto
}

struct StorePropertiesDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "store_id"
        case name = "name"
        case contact = "contact"
        case hours = "weekly_opening"
    }
    let id: String
    let name: String
    let contact: StoreContactDto?
    let hours: WeeklyStoreScheduleDto
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
}

struct WhatIsOpenPaginationDto: Decodable {
    let page: Int
    let pageCount: Int
}
