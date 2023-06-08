//
//  WhatsOpenEnums.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/8/23.
//

import Foundation

enum DayOfTheWeek: String {
    case Monday, Tuesday, Webnesday, Thursday, Friday, Saturday, Sunday
}

enum WhatIsOpenCategories: String, CaseIterable {
//    case emu, llc, unthank, carson,
    case dining, coffee, recreation, library, grocery, building, bank, other, closed
    case duckStore = "duck store"
}

enum WoosmapDays: String {
    case monday
    case tuesday
    case wednsday
    case thursday
    case friday
    case saturday
    case sunday
    case notADay

    init(dayNumber: Int) {
        if dayNumber == 1 {
            self.init(rawValue: "monday")!
        } else if dayNumber == 2 {
            self.init(rawValue: "tuesday")!
        } else if dayNumber == 3 {
            self.init(rawValue: "wednsday")!
        } else if dayNumber == 4 {
            self.init(rawValue: "thursday")!
        } else if dayNumber == 5 {
            self.init(rawValue: "friday")!
        } else if dayNumber == 6 {
            self.init(rawValue: "saturday")!
        } else if dayNumber == 7 {
            self.init(rawValue: "sunday")!
        } else {
            self.init(rawValue: "notADay")!
        }
    }

    var todayDate: Date {
        switch self {
        case .monday:
            return getDates()[0]
        case .tuesday:
            return getDates()[1]
        case .wednsday:
            return getDates()[2]
        case .thursday:
            return getDates()[3]
        case .friday:
            return getDates()[4]
        case .saturday:
            return getDates()[5]
        case .sunday:
            return getDates()[6]
        case .notADay:
            return getDates()[0]
        }
    }

    var mondayDate: Date {
        getDates()[0]
    }
    var tuesdayDate: Date {
        getDates()[1]
    }
    var wednsdayDate: Date {
        getDates()[2]
    }
    var thursdayDate: Date {
        getDates()[3]
    }
    var fridayDate: Date {
        getDates()[4]
    }
    var saturdayDate: Date {
        getDates()[5]
    }
    var sundayDate: Date {
        getDates()[6]
    }

    private func getDates() -> [Date] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "America/Los_Angeles")!
        let startOfToday: Date = calendar.startOfDay(for: Date())
        var daysArray: [Int] {
            switch self {
            case .monday:
                return [0, 1, 2, 3, 4, 5, 6]
            case .tuesday:
                return [-1, 0, 1, 2, 3, 4, 5]
            case .wednsday:
                return [-2, -1, 0, 1, 2, 3, 4]
            case .thursday:
                return [-3, -2, -1, 0, 1, 2, 3]
            case .friday:
                return [-4, -3, -2, -1, 0, 1, 2]
            case .saturday:
                return [-5, -4, -3, -2, -1, 0, 1]
            case .sunday:
                return [-6, -5, -4, -3, -2, -1, 0]
            case .notADay:
                return [Int](repeating: 0, count: 7)
            }
        }
        var returnArray = [Date]()
        for dayInt in daysArray {
            returnArray.append(Date(timeInterval: getTimeInterval(forNumberOfDays: dayInt), since: startOfToday))
        }
        return returnArray
    }

    private func getTimeInterval(forNumberOfDays days: Int) -> TimeInterval {
        TimeInterval(60*60*24*days) // Seconds * Minutes * Hours * days
    }
}
