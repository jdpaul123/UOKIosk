//
//  WhatIsOpenService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/6/23.
//

import Foundation
import Collections

class WhatIsOpenService: WhatIsOpenRepository {
    private let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    func getAssetData() async throws -> [WhatIsOpenCategories: [WhatIsOpenPlace]] {
        // get the data from the ApiService. Turn the returned Dto object into a view model so that the data can be displayed
        var whatIsOpenDto: WhatIsOpenDto? = nil
        do {
            whatIsOpenDto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            throw error
        }

        // Go through each new "Asset". Create the current asset's PlaceViewModel with all of the correct data
        guard let whatIsOpenDto = whatIsOpenDto else {
            return [:]
        }

        return fillViewModelData(dto: whatIsOpenDto)
    }

    func fillViewModelData(dto: WhatIsOpenDto) -> [WhatIsOpenCategories: [WhatIsOpenPlace]] {
        var (dining, coffee, duckStore, recreation, library, grocery, building, bank, other, closed) = ([WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace](), [WhatIsOpenPlace]())

        for asset in dto.features {
            let today = WoosmapDays(dayNumber: asset.properties.open.today)

            // FIXME: BELOW CODE IS FOR TESTING
            /*
            print()
            print("Monday is: \(today.mondayDate)")
            print("Tuesday is: \(today.tuesdayDate)")
            print("Wednsday is: \(today.wednsdayDate)")
            print("Thursday is: \(today.thursdayDate)")
            print("Friday is: \(today.fridayDate)")
            print("Saturday is: \(today.saturdayDate)")
            print("Sunday is: \(today.sundayDate)")
            print()
            */

            var mondayHours = [DateInterval]()
            var tuesdayHours = [DateInterval]()
            var wednsdayHours = [DateInterval]()
            var thursdayHours = [DateInterval]()
            var fridayHours = [DateInterval]()
            var saturdayHours = [DateInterval]()
            var sundayHours = [DateInterval]()

            fillHours(hoursDto: asset.properties.hours.monday.hours, hours: &mondayHours, dayAtMidnight: today.mondayDate)
            fillHours(hoursDto: asset.properties.hours.tuesday.hours, hours: &tuesdayHours, dayAtMidnight: today.tuesdayDate)
            fillHours(hoursDto: asset.properties.hours.wednsday.hours, hours: &wednsdayHours, dayAtMidnight: today.wednsdayDate)
            fillHours(hoursDto: asset.properties.hours.thursday.hours, hours: &thursdayHours, dayAtMidnight: today.thursdayDate)
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

                return Date(timeInterval: timeInterval, since: since)
            }

            // FIXME: BELOW CODE IS FOR TESTING
            /*
            print()
            print("For \(asset.properties.name) the hours on Monday are: \(mondayHours)")
            print("The hours on Tuesday are: \(tuesdayHours)")
            print("The hours on Tuesday are: \(wednsdayHours)")
            print("The hours on Tuesday are: \(thursdayHours)")
            print("The hours on Tuesday are: \(fridayHours)")
            print("The hours on Tuesday are: \(saturdayHours)")
            print("The hours on Tuesday are: \(sundayHours)")
            print()
             */

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

            let mondayIntervalString = intervalString(hours: mondayHours)
            let tuesdayIntervalString = intervalString(hours: tuesdayHours)
            let wednsdayIntervalString = intervalString(hours: wednsdayHours)
            let thursdayIntervalString = intervalString(hours: thursdayHours)
            let fridayIntervalString = intervalString(hours: fridayHours)
            let saturdayIntervalString = intervalString(hours: saturdayHours)
            let sundayIntervalString = intervalString(hours: sundayHours)

            let hours: OrderedDictionary<String, String> = [
                "Monday": mondayIntervalString,
                "Tuesday": tuesdayIntervalString,
                "Wednsday": wednsdayIntervalString,
                "Thursday": thursdayIntervalString,
                "Friday": fridayIntervalString,
                "Saturday": saturdayIntervalString,
                "Sunday": sundayIntervalString
            ]
            /*
             TODO: This is a dynamic programming problem. The results could be in a 2D graph where the x-axis is days Monday through Friday and the y-axis is the same
             Once you got the range from Monday to whenever the time interval for open-hours changes you would start on the next day.
             For example, if the range went from Monday through Friday then the next dynamic programming calculation would start at Saturday.
             Monday
             Monday - Tuesday
             Monday - Wednsday
             Monday - Thursday
             Monday - Friday
             Monday - Saturday
             Monday - Sunday
             if mondayIntervalString == tuesdayIntervalString {
                Monday-Tuesday: mondayIntervalString
                if
             }
             */

            // FIXME: BELOW CODE IS FOR TESTING
            /*
            print()
            print(hours)
            print()
             */

            let vm = WhatIsOpenPlace(name: asset.properties.name,
                                     emojiCode: asset.properties.userProperties.emoji ?? "💚",
                                     building: asset.properties.userProperties.building,
                                     mapLink: URL(string: "www.youtube.com"), // TODO: Youtube is a placeholder
                                     websiteLink: URL(string: asset.properties.contact?.website ?? ""),
                                     until: until,
                                     isOpen: asset.properties.open.isOpen,
                                     hours: hours,
                                     hoursIntervals: [mondayHours, tuesdayHours, wednsdayHours, thursdayHours, fridayHours, saturdayHours, sundayHours])
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
            case "grocery":
                grocery.append(vm)
            case "building":
                building.append(vm)
            case "bank":
                bank.append(vm)
            default:
                other.append(vm)
            }
        }

        let returnDictionary: [WhatIsOpenCategories: [WhatIsOpenPlace]] = [.dining: dining, .coffee: coffee, .duckStore: duckStore, .recreation: recreation, .library: library,
                                                                          .closed: closed, .grocery: grocery, .building: building, .bank: bank, .other: other]
        return returnDictionary
    }
}
