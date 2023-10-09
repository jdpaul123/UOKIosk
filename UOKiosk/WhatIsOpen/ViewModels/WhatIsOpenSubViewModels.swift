//
//  WhatIsOpenSubViewModels.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/13/23.
//

import SwiftUI
import Combine
import Collections

class WhatIsOpenListViewModel: ObservableObject {
    let listType: WhatIsOpenCategories
    @Published var places: [WhatIsOpenPlace]
    @Published var placesResults: [WhatIsOpenPlace]
    var cancellables = Set<AnyCancellable>()

    init(places: [WhatIsOpenPlace], listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel) {
        self.listType = listType
        self.places = places
        self.placesResults = places

        parentViewModel.$searchText
            .map { searchText in
                self.places
                    .sorted(by: { $0.building ?? "" < $1.building ?? "" })
                    .filter({ whatIsOpenPlace in
                        if searchText == "" { return true }
                        return whatIsOpenPlace.name.lowercased().contains((searchText.lowercased()))
                        || whatIsOpenPlace.name.lowercased().contains(searchText.lowercased())
                    })
            }
            .assign(to: &self.$placesResults)

        listType.getWhatIsOpenViewModelData(vm: parentViewModel)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                self.cancellables.removeAll()
            } receiveValue: { [weak self] places in
                guard let self = self else { return }
                self.places = places.sorted(by: { $0.building ?? "" < $1.building ?? "" })
                self.placesResults = self.places.sorted(by: { $0.building ?? "" < $1.building ?? "" })
            }
            .store(in: &cancellables)
    }
}

class WhatIsOpenPlaceViewModel: ObservableObject {
    let emoji: String
    let name: String
    let building: String?
    let mapLink: URL?
    let websiteLink: URL?
    let hoursIntervals: [[DateInterval]]
    let until: Date
    @Published var isOpenString: String
    @Published var isOpenColor: Color

    var cancelables = Set<AnyCancellable>()

    // dayRangess and hoursOpen should be the same length and the nth item in each arrayu are paired up
    // Key: Each string is either one day (ex. "Monday") or a range (ex "Monday - Friday")
    // Value: Each string is either "closed", a single time range (ex. "7:00a-10:00p"), or multiple ranges split by newlines (ex. "7:00a-12:00\n1:00p-10:00p")
    let hours: OrderedDictionary<String, String>

    // Until parameter represents, at time of instantiation, when the place will close if it is open, or open if it is closed.
    init(emojiCode: String, name: String, building: String?, mapLink: URL?, websiteLink: URL?, isOpenString: String, isOpenColor: Color, until: Date, hours: OrderedDictionary<String, String>, hoursIntervals: [[DateInterval]]) {
        self.emoji = emojiCode
        self.name = name
        self.building = building
        self.mapLink = mapLink
        self.websiteLink = websiteLink
        self.isOpenString = isOpenString
        self.isOpenColor = isOpenColor
        self.hours = hours
        self.hoursIntervals = hoursIntervals
        self.until = until
        setUpTimer()
    }

    func isClosedColor(closedValue: String) -> Color? {
        if closedValue.lowercased() == "closed" {
            return Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
        }
        return nil
    }


    private func setUpTimer() {
        Timer
            .publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

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
                // In theory: This code should never be hit unless the store has passed its last closing time for the week
                isOpenColor = .red
                let cal = Calendar(identifier: .gregorian)
                let on = cal.isDate(Date.now, inSameDayAs: until) ? "": "on \(until.dayOfWeek() ?? "")"

                guard !cal.isDateInTomorrow(until) else {
                    isOpenString = "Closed until \(timeFormatter.string(from: until)) tomorrow"
                    return
                }
                isOpenString = "Closed until \(timeFormatter.string(from: until)) \(on)"
            }
            .store(in: &cancelables)
    }
}
