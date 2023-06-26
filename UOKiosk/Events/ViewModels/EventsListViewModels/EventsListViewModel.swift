//
//  EventsListViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Collections
import CoreData

class EventsListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    // MARK: Properties
    // Data Properties
    let eventsRepository: EventsRepository
    private var resultsController: NSFetchedResultsController<Event>?
//    @Published var eventsDictionary = OrderedDictionary<Date, [Event]>()
//    var events: [Event] {
//        resultsController?.fetchedObjects ?? []
//    }
    @Published var eventsDictionary = OrderedDictionary<Date, [Event]>()

    // View State Properties
    @Published var showingInformationSheet = false
    @Published var isLoading: Bool = false
    var showLoading: Bool {
        if isLoading, eventsDictionary.isEmpty {
            return true
        }
        return false
    }
    @Published var viewModelHasLoaded = false
    // Banner Properties
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)

    // MARK: Initializer
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
        super.init()
        self.resultsController = eventsRepository.fetchSavedEvents(with: self)
    }

    // MARK: Fetch Events
    @MainActor
    func fetchEvents() async {
        isLoading = true
        defer { isLoading = false }
        do {
            resultsController = try await eventsRepository.fetchEvents(with: self)
//            events = try await eventsRepository.getFreshEvents()
        } catch {
            bannerData.title = "Error"
            bannerData.detail = error.localizedDescription
            showBanner = true
            return
        }

        let events: [Event] = resultsController?.fetchedObjects ?? []

        let cal = Calendar(identifier: .gregorian)
        for event in events {
            // Get date at midnight
//            guard let start = event.start else { continue }
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
