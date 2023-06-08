//
//  WhatIsOpenService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/6/23.
//

import Foundation
import Collections

// https://www.hackingwithswift.com/example-code/language/how-to-make-array-access-safer-using-a-custom-subscript
extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}

// https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift
extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}

enum WhatIsOpenCategories: String {
    case dining, coffee, recreation, library, closed
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

class WhatIsOpenService {
    func getAssetData(url: String) async throws -> [WhatIsOpenCategories: [PlaceViewModel]] {
        // get the data from the ApiService. Turn the returned Dto object into a view model so that the data can be displayed
        var whatIsOpenDto: WhatIsOpenDto? = nil
        do {
            whatIsOpenDto = try await ApiService.shared.getJSON(urlString: url)
        } catch {
            fatalError("FAILED TO GET THE DATA WITH ERROR")
        }

        // Go through each new "Asset"
        // Create the current asset's PlaceViewModel with all of the correct data
        // Place each store into the correct array based off of its type (ie. dining, coffee, duckStore, recreation, library, closed)
        // Instantiate and return the WhatIsOpenViewModel
        guard let whatIsOpenDto = whatIsOpenDto else {
            return [:]
        }

        var (dining, coffee, duckStore, recreation, library, closed) = ([PlaceViewModel](), [PlaceViewModel](), [PlaceViewModel](), [PlaceViewModel](), [PlaceViewModel](), [PlaceViewModel]())

        for asset in whatIsOpenDto.features {
            let today = WoosmapDays(dayNumber: asset.properties.open.today)

            // FIXME: BELOW CODE IS FOR TESTING
            print()
            print("Monday is: \(today.mondayDate)")
            print("Tuesday is: \(today.tuesdayDate)")
            print("Wednsday is: \(today.wednsdayDate)")
            print("Thursday is: \(today.thursdayDate)")
            print("Friday is: \(today.fridayDate)")
            print("Saturday is: \(today.saturdayDate)")
            print("Sunday is: \(today.sundayDate)")
            print()

            var mondayHours = [DateInterval]()
            var tuesdayHours = [DateInterval]()
            var wednsdayHours = [DateInterval]()
            var thurdayHours = [DateInterval]()
            var fridayHours = [DateInterval]()
            var saturdayHours = [DateInterval]()
            var sundayHours = [DateInterval]()

            fillHours(hoursDto: asset.properties.hours.monday.hours, hours: &mondayHours, dayAtMidnight: today.mondayDate)
            fillHours(hoursDto: asset.properties.hours.tuesday.hours, hours: &tuesdayHours, dayAtMidnight: today.tuesdayDate)
            fillHours(hoursDto: asset.properties.hours.wednsday.hours, hours: &wednsdayHours, dayAtMidnight: today.wednsdayDate)
            fillHours(hoursDto: asset.properties.hours.thursday.hours, hours: &thurdayHours, dayAtMidnight: today.thursdayDate)
            fillHours(hoursDto: asset.properties.hours.friday.hours, hours: &fridayHours, dayAtMidnight: today.fridayDate)
            fillHours(hoursDto: asset.properties.hours.saturday.hours, hours: &saturdayHours, dayAtMidnight: today.saturdayDate)
            fillHours(hoursDto: asset.properties.hours.sunday.hours, hours: &sundayHours, dayAtMidnight: today.sundayDate)

            func fillHours(hoursDto: [OpenHoursIntervalDto], hours: inout [DateInterval], dayAtMidnight: Date) {
                for setOfHours in hoursDto {
                    let startDate = getDateStartingFromTime(timeString: setOfHours.start, since: dayAtMidnight)
                    let endDate = getDateStartingFromTime(timeString: setOfHours.end, since: dayAtMidnight)
                    hours.append(DateInterval(start: startDate, end: endDate))
                }
            }

            // timeString example: 07:20 so we want the first two characters for the hour and last two characters for the minute
            func getDateStartingFromTime(timeString: String, since: Date) -> Date {
                let firstHourDigit: String = String(timeString[0])
                let secondHourDigit: String = String(timeString[1])
                let firstMinuteDigit: String = String(timeString[3])
                let secondMinuteDigit: String = String(timeString[4])
                // TODO: Create an error if the code does not get an integer value from the next two operations because it always should
                let timeHours: Int = Int(String(firstHourDigit+secondHourDigit)) ?? 0
                let timeMinutes: Int = Int(String(firstMinuteDigit+secondMinuteDigit)) ?? 0
                let timeHoursInSeconds: Int = 60*60*timeHours //Seconds*Minutes*Hours
                let timeMinutesInSeconds: Int = 60*timeMinutes // Seconds*Minutes
                var timeSeconds: Int { timeMinutes == 59 ? 59 : 0 }
                let timeInterval = TimeInterval(timeHoursInSeconds+timeMinutesInSeconds+timeSeconds)
                return Date(timeInterval: timeInterval, since: today.mondayDate)
            }

            // FIXME: BELOW CODE IS FOR TESTING
            print()
            print("For \(asset.properties.name) the hours on Monday are: \(mondayHours)")
            print("The hours on Tuesday are: \(tuesdayHours)")
            print("The hours on Tuesday are: \(wednsdayHours)")
            print("The hours on Tuesday are: \(thurdayHours)")
            print("The hours on Tuesday are: \(fridayHours)")
            print("The hours on Tuesday are: \(saturdayHours)")
            print("The hours on Tuesday are: \(sundayHours)")
            print()

            var todaysHours: [DateInterval] {
                switch today {
                case .monday:
                    return mondayHours
                case .tuesday:
                    return tuesdayHours
                case .wednsday:
                    return wednsdayHours
                case .thursday:
                    return thurdayHours
                case .friday:
                    return fridayHours
                case .saturday:
                    return saturdayHours
                case .sunday:
                    return sundayHours
                case .notADay:
                    return []
                }
            }

            var until = Date(timeIntervalSince1970: 0)
            if let currentSlice = asset.properties.open.currentSlice { // This means the store is opened
                until = getDateStartingFromTime(timeString: currentSlice.end, since: today.todayDate)
            } else if let nextOpening = asset.properties.open.nextOpening { // This means the store is closed
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .init(identifier: "America/Los_Angeles")!
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let since = dateFormatter.date(from: nextOpening.dateString)!
                until = getDateStartingFromTime(timeString: nextOpening.start, since: since)
            }

            let dateIntervalFormatter = DateIntervalFormatter()
            dateIntervalFormatter.calendar = .init(identifier: .gregorian)
            dateIntervalFormatter.timeZone = .init(identifier: "America/Los_Angeles")!
            dateIntervalFormatter.dateStyle = .none
            dateIntervalFormatter.timeStyle = .short

            func intervalString(hours: [DateInterval]) -> String {
                var intervalString = ""
                for interval in hours {
                    if intervalString != "" {
                        intervalString += "\n"
                    }
                    intervalString += dateIntervalFormatter.string(from: interval) ?? ""
                }
                if intervalString.isEmpty {
                    intervalString = "Closed"
                }
                return intervalString
            }

            var mondayIntervalString = intervalString(hours: mondayHours)
            var tuesdayIntervalString = intervalString(hours: tuesdayHours)
            var wednsdayIntervalString = intervalString(hours: wednsdayHours)
            var thursdayIntervalString = intervalString(hours: thurdayHours)
            var fridayIntervalString = intervalString(hours: fridayHours)
            var saturdayIntervalString = intervalString(hours: saturdayHours)
            var sundayIntervalString = intervalString(hours: sundayHours)

            var hours: OrderedDictionary<String, String> = [
                "Monday": mondayIntervalString,
                "Tuesday": tuesdayIntervalString,
                "Wednsday": wednsdayIntervalString,
                "Thursday": thursdayIntervalString,
                "Friday": fridayIntervalString,
                "Saturday": saturdayIntervalString,
                "Sunday": sundayIntervalString
            ]

            // FIXME: BELOW CODE IS FOR TESTING
            print()
            print(hours)
            print()

            let vm = PlaceViewModel(name: asset.properties.name,
                           emojiCode: asset.properties.userProperties.emoji ?? "💚",
                           mapLink: URL(string: "www.youtube.com"), // TODO: Youtube is a placeholder
                           WebSieLink: URL(string: asset.properties.contact?.website ?? ""),
                           until: until,
                           isOpen: asset.properties.open.isOpen,
                           hours: hours)
            let assetCategory = asset.properties.types[0, default: ""]
            switch assetCategory {
            case "dining":
                dining.append(vm)
            case "coffee":
                coffee.append(vm)
            case "duckStore":
                duckStore.append(vm)
            case "recreation":
                recreation.append(vm)
            case "library":
                library.append(vm)
            default:
                continue
            }
        }

        let returnDictionary: [WhatIsOpenCategories: [PlaceViewModel]] = [.dining: dining, .coffee: coffee, .duckStore: duckStore, .recreation: recreation, .library: library, .closed: closed]
        return returnDictionary
    }
}
