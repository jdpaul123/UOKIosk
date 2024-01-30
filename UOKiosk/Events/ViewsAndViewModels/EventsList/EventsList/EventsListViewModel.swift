//
//  EventsListViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Collections

@MainActor
class EventsListViewModel: NSObject, ObservableObject {
    // MARK: Properties
    // Data Properties
    let eventsRepository: EventsRepository
    @Published var eventsDictionary = OrderedDictionary<Date, [Event]>()
    @Published var events = [Event]()

    // View State Properties
    @Published var showingInformationSheet = false
    @Published var viewModelHasLoaded = false
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData
    @Published var isLoading: Bool = false
    var showLoading: Bool {
        if isLoading, eventsDictionary.isEmpty {
            return true
        }
        return false
    }

    // MARK: Initializer
    init(eventsRepository: EventsRepository, bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)) {
        self.eventsRepository = eventsRepository
        self.bannerData = bannerData
        super.init()
    }

    // MARK: Fetch Events
    func fetchEvents() async {
        isLoading = true
        defer {
            isLoading = false
            viewModelHasLoaded = true
        }
        do {
            events = try await eventsRepository.fetchSavedEvents()
        } catch {
            bannerData.title = "Error"
            bannerData.detail = error.localizedDescription
            showBanner = true
            return
        }

        Task {
            await fetchFreshEvents()
            await fetchImages()
        }

        fillEventsDictionary()
    }

    private func fetchFreshEvents() async {
        if let events = try? await eventsRepository.fetchFreshEvents() {
            self.events = events
        }
        fillEventsDictionary()
    }

    private func fetchImages() async {
        for event in events {
            await eventsRepository.getImage(for: event)
        }
        fillEventsDictionary()
    }

    private func fillEventsDictionary() {
        var eventsDictionary = OrderedDictionary<Date, [Event]>()

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

        self.eventsDictionary = eventsDictionary
    }
}
