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
    let pagination: Pagination
    let features: [Feature]
}

struct Feature: Decodable {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case properties = "properties"
    }
    let type: String
    let properties: StoreProperties
}

struct StoreProperties: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "store_id"
        case name = "name"
        case contact = "contact"
        case hours = "weekly_opening"
    }
    let id: String
    let name: String
    let contact: StoreContact?
    let hours: WeeklyStoreSchedule
}

struct WeeklyStoreSchedule: Decodable {
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
    let monday: StoreDay
    let tuesday: StoreDay
    let wednsday: StoreDay
    let thursday: StoreDay
    let friday: StoreDay
    let saturday: StoreDay
    let sunday: StoreDay
}

struct StoreDay: Decodable {
    let hours: [StoreHours]
    let isSpecial: Bool
}

struct StoreHours: Decodable {
    let start: String
    let end: String
}

struct StoreContact: Decodable {
    let phone: String?
}

struct Pagination: Decodable {
    let page: Int
    let pageCount: Int
}
