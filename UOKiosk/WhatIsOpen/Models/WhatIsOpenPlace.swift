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
    let until: Date
    let hours: OrderedDictionary<String, String>
    let hoursIntervals: [[DateInterval]]

    // For the Until: Date value: If open, then this value is used as an indicator of when the place closes next. If closed, then this value is used as an indicator of when the place opens next
    init(name: String, emojiCode: String, building: String?, mapLink: URL?, websiteLink: URL?, until: Date, isOpen: Bool, hours: OrderedDictionary<String, String>, hoursIntervals: [[DateInterval]]) {
        self.name = name
        self.emoji = emojiCode
        self.building = building
        self.mapLink = mapLink
        self.websiteLink = websiteLink
        self.until = until
        self.hours = hours
        self.hoursIntervals = hoursIntervals

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

                guard !cal.isDateInTomorrow(startTime) else {
                    isOpenString = "Closed until \(timeFormatter.string(from: startTime)) tomorrow"
                    return
                }
                isOpenString = "Closed until \(timeFormatter.string(from: startTime)) \(on)"
                return
            }
        }

        isOpenColor = .red

        let cal = Calendar(identifier: .gregorian)
        let on = cal.isDate(Date.now, inSameDayAs: until) ? "": "on \(until.dayOfWeek() ?? "")"

        guard !cal.isDateInTomorrow(until) else {
            isOpenString = "Closed until \(timeFormatter.string(from: until)) tomorrow"
            return
        }
        isOpenString = "Closed until \(timeFormatter.string(from: until)) \(on)"
    }
}
