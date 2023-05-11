//
//  EventsViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/23/22.
//

import Foundation
import CoreData

final class EventsViewModel: NSObject, ObservableObject, Identifiable, NSFetchedResultsControllerDelegate {
    // MARK: Properties
    let id: String = UUID().uuidString
    var allEvents: [Event] {
        resultsController?.fetchedObjects ?? []
    }

    @Published var isLoading: Bool
    @Published var showAlert: Bool
    @Published var errorMessage: String?

    @Published var eventsInADay: [EventsViewModelDay]
    @Published private var lastDataUpdateDate: String {
        didSet {
            // Save the day date that the data is updated to compare with the date on subsiquent application boot ups.
            UserDefaults.standard.set(lastDataUpdateDate, forKey: "lastDataUpdateDate")
        }
    }

    private let eventsRepository: EventsRepository
    private var resultsController: NSFetchedResultsController<Event>? = nil
   
    // MARK: Initialization
    init(eventsRepository: EventsRepository, isLoading: Bool = false, showAlert: Bool = false, errorMessage: String? = nil) {
        self.eventsRepository = eventsRepository
        self.eventsInADay = []
        self.errorMessage = errorMessage

        self.isLoading = isLoading
        self.showAlert = showAlert
        
        // Check if the lastDataUpdateDate is not the same day as today
        // If the app has never been opened and loaded data, then the last date is "" which will not equal the current
        // date, so it will trigger the data loading method
        self.lastDataUpdateDate = UserDefaults.standard.object(forKey: "lastDataUpdateDate") as? String ?? ""
        super.init()
        self.resultsController = eventsRepository.fetchSavedEvents(with: self)
        
        #if DEBUG
        print("On instantiation of the EventsViewModel the value loaded in for the last data update date is \(lastDataUpdateDate).")
        #endif
    }
    
    // MARK: NSFetchedResultsController
    // This function enables change tracking so that data stays up to date in the view when updates are made
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // objectWillChange is the publisher of the ObservableObject protocol that emits the changed value before any
        // of its @Pubished properties changs. Here we are manually saying that something has changed whenever
        // the results controller gets changed.
        objectWillChange.send()
    }

    // MARK: Data Filling Functions
    @MainActor
    func fetchEvents(shouldCheckLastUpdateDate: Bool = false) async {
        /*
         Callers:
                When the Events View loads, this function is called.
                When pull to refresh is triggered, this function is called.

         Parameters:
            shouldCheckLastUpdateDate:
                If this is true then the function will check if the app made an API request for fresh data that day.
                If so, then the app will not make an API request for fresh data and will instead use the data stored
                in the Core Data Persistent Store.

         Description:
             This function calls to get new events data.

             On Events View loading this function will not make an API request for fresh data if it already
             loaded fresh data that day.

             However, if the user is performing a pull to refresh then the function should make an API call
             to get the most up to date data.
         */
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }

        let todaysDate = Date().formatted(date: .complete, time: .omitted)
        
        // Do not update the data if shouldCheckLastUpdateData is true and data was alread loaded from the API today
        if shouldCheckLastUpdateDate, self.lastDataUpdateDate == todaysDate {
            self.fillData()
            return
        }
        self.lastDataUpdateDate = todaysDate
        guard let resultsController = resultsController else {
            return
        }
        do {
            try await eventsRepository.fetchNewEvents(eventResultsController: resultsController)
        } catch {
            // TODO: Add error handling here: The showAlert bool and message are already set up. Just need to show the error
            showAlert = true
            errorMessage = error.localizedDescription + " No Events were returned from the events repository fetchNewEvents method"
            print("No Events were returned from the events repository fetchNewEvents method")
            return
        }
        self.fillData()
    }
    
    
    // Takes the model and uses that data to fill in the values for this view controller.
    private func fillData() {
        DispatchQueue.main.async { [self] in
            eventsInADay = []

            var compareDateString: String = ""
            for event in allEvents {
                guard let start = event.start else {
                    continue // TODO: For now, skip the event if it has no start time
                }
                let currDateString: String = start.formatted(date: .abbreviated, time: .omitted)

                // If the last date we save is not the same as the current date, then start a new day
                if compareDateString != currDateString {
                    eventsInADay.append(EventsViewModelDay(dateString: currDateString))
                    compareDateString = currDateString
                }
                eventsInADay.last!.events.append(EventCellViewModel(event: event))
            }
        }
    }
}
