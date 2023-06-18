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
    var cancellables = Set<AnyCancellable>()

    init(places: [WhatIsOpenPlace], listType: WhatIsOpenCategories, parentViewModel: WhatIsOpenViewModel) {
        self.listType = listType
        self.places =  places
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
                self?.places = places.sorted(by: { $0.building ?? "" < $1.building ?? "" })
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
    @Published var isOpenString: String
    @Published var isOpenColor: Color

    var cancelables = Set<AnyCancellable>()

    // dayRangess and hoursOpen should be the same length and the nth item in each arrayu are paired up
    // Key: Each string is either one day (ex. "Monday") or a range (ex "Monday - Friday")
    // Value: Each string is either "closed", a single time range (ex. "7:00a-10:00p"), or multiple ranges split by newlines (ex. "7:00a-12:00\n1:00p-10:00p")
    let hours: OrderedDictionary<String, String>

    init(emojiCode: String, name: String, building: String?, mapLink: URL?, websiteLink: URL?, isOpenString: String, isOpenColor: Color, hours: OrderedDictionary<String, String>, hoursIntervals: [[DateInterval]]) {
        self.emoji = emojiCode
        self.name = name
        self.building = building
        self.mapLink = mapLink
        self.websiteLink = websiteLink
        self.isOpenString = isOpenString
        self.isOpenColor = isOpenColor
        self.hours = hours
        self.hoursIntervals = hoursIntervals
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
                isOpenColor = .red
                // TODO: Get the next open time value from the api task and show that time
                isOpenString = "Closed until at least Monday"
            }
            .store(in: &cancelables)
    }
}
