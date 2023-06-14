//
//  WhatIsOpenPlace.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/11/23.
//

import Foundation
import Collections
import SwiftUI

struct WhatIsOpenPlace: Identifiable {
    var id = UUID()
    let emoji: String
    let name: String
    let building: String?
    let mapLink: URL?
    let websiteLink: URL?
    let isOpenString: String
    let isOpenColor: Color
    let hours: OrderedDictionary<String, String>
    let hoursIntervals: [[DateInterval]]

    // For the Until: Date value: If open, then this value is used as an indicator of when the place closes next. If closed, then this value is used as an indicator of when the place opens next
    init(name: String, emojiCode: String, building: String?, mapLink: URL?, websiteLink: URL?, until: Date, isOpen: Bool, hours: OrderedDictionary<String, String>, hoursIntervals: [[DateInterval]]) {
        self.name = name
        self.emoji = emojiCode
        self.building = building
        self.mapLink = mapLink
        self.websiteLink = websiteLink
        self.hours = hours
        self.isOpenColor = isOpen ? .green: .red
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let on: String = {
            if isOpen { return "" }
            if Calendar(identifier: .gregorian).compare(Date.now, to: until, toGranularity: .day) == .orderedSame {
                return ""
            }
            if Calendar(identifier: .gregorian).isDateInTomorrow(until) {
                return "tomorrow"
            }
            return "on \(until.dayOfWeek() ?? "")"
        }()
        self.isOpenString = "\(isOpen ? "Open": "Closed") until \(formatter.string(from: until)) \(on)"
        self.hoursIntervals = hoursIntervals
    }
}
