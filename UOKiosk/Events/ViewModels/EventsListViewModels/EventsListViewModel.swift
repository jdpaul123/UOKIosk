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

    @Published var showingInformationSheet = false

    @Published var isLoading: Bool = false
    var showLoading: Bool {
        if isLoading, eventsDictionary.isEmpty {
            return true
        }
        return false
    }

    @Published var viewModelHasLoaded = false

    @Published var eventsDictionary = OrderedDictionary<Date, [IMEvent]>()

    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)

    // MARK: Initializer
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
    }

    // MARK: Fetch Events
    @MainActor
    func fetchEvents() async {
        isLoading = true
        defer { isLoading = false }

        /*
         TODO: Call service to get events.
         The service will decide if it just gets data from the Core Data Persistent Store
         or if it calls the api for fresh data, waits for it, and returns data from the Persistent Store.

         Once that works, impliment pull-to-refrehs which will perform the fetchEvents that is described above but it will call
         the api every time.
         */

        var events = [IMEvent]()
        do {
            events = try await eventsRepository.getFreshEvents()
        } catch {
            bannerData.title = "Error"
            bannerData.detail = error.localizedDescription
            showBanner = true
            return
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
        viewModelHasLoaded = true
    }
}
