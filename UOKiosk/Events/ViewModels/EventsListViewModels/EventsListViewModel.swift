//
//  EventsListViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Collections

class EventsListViewModel: ObservableObject {
    let eventsRepository: EventsRepository

    @Published var isLoading: Bool = false
    var showLoading: Bool {
        if isLoading, eventsDictionary.isEmpty {
            return true
        }
        return false
    }

    @Published var eventsDictionary = OrderedDictionary<Date, [IMEvent]>()

    // MARK: Initializer
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
    }

    // MARK: Fetch Events
    func fetchEvents() async {
        var events = [IMEvent]()
        do {
            events = try await eventsRepository.getFreshEvents()
        } catch {
            print("!! FAILED TO GET EVENTS")
        }

        let cal = Calendar(identifier: .gregorian)
        for event in events {
            // Get date at midnight
            let day = cal.component(.day, from: event.start)
            let month = cal.component(.month, from: event.start)
            let year = cal.component(.year, from: event.start)
            let startOfEventAtMidnight = cal.date(from: DateComponents(year: year, month: month, day: day))!
            if eventsDictionary[startOfEventAtMidnight] != nil {
                eventsDictionary[startOfEventAtMidnight]?.append(event)
            } else {
                eventsDictionary[startOfEventAtMidnight] = [event]
            }
        }
        print("Events: \(events)")
    }
}
