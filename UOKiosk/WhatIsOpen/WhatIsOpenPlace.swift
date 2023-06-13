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
    let note: String? // Contains the building the store/facility is located in or a fun note
    let mapLink: URL?
    let WebSieLink: URL?
    var isOpenString: String
    var isOpenColor: Color
    let hours: OrderedDictionary<String, String>
    let hoursIntervals: [[DateInterval]]

    // For the Until: Date value: If open, then this value is used as an indicator of when the place closes next. If closed, then this value is used as an indicator of when the place opens next
    init(name: String, emojiCode: String, note: String? = nil, mapLink: URL?, WebSieLink: URL?, until: Date, isOpen: Bool, hours: OrderedDictionary<String, String>, hoursIntervals: [[DateInterval]]) {
        self.name = name
        self.emoji = emojiCode
        self.note = note
        self.mapLink = mapLink
        self.WebSieLink = WebSieLink
        self.hours = hours
        self.isOpenColor = isOpen ? .green: .red
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let on: String = {
            if isOpen { return "" }
            if Calendar(identifier: .gregorian).compare(Date.now, to: until, toGranularity: .day) == .orderedSame {
                return ""
            }
            return "on \(until.dayOfWeek() ?? "")"
        }()
        self.isOpenString = "\(isOpen ? "Open": "Closed") until \(formatter.string(from: until)) \(on)"
        self.hoursIntervals = hoursIntervals
    }
}
