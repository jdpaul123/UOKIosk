//
//  EventsViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/23/22.
//

import Foundation
import CoreData

final class EventsViewModel: NSObject, ObservableObject, Identifiable, NSFetchedResultsControllerDelegate {
    /*
     Contains all of the data for the Events View to display
     */
    
    // MARK: Properties
    let id: String = UUID().uuidString
    var allEvents: [Event] {
        resultsController?.fetchedObjects ?? []
    }
    @Published var eventsInADay: [EventsViewModelDay]
    @Published var lastDataUpdateDate: String {
        didSet {
            // Save the day date that the data is updated to compare with the date on subsiquent application boot ups.
            UserDefaults.standard.set(lastDataUpdateDate, forKey: "lastDataUpdateDate")
        }
    }
    private let eventsRepository: EventsRepository
    private var resultsController: NSFetchedResultsController<Event>? = nil
    
    // MARK: NSFetchedResultsController
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }

    
    // MARK: Initialization
    init(eventsRepository: EventsRepository) { // TODO: Why not use override like in the example here?
        self.eventsRepository = eventsRepository
        self.eventsInADay = []
        
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
    
    // MARK: Data Filling Functions
    func fetchEvents(shouldCheckLastUpdateDate: Bool = false) {
        /*
         This function calls to get new events data.
         
         The function should not get events if the app opens, but the last time data was retrieved
         was the day as the apps current opening hense on load should call with shouldCheckLastUpdateDate
         containing the value true
         
         If the user is trying to pull to refresh then shouldCheckLastUpdateDate should not matter
         and the app should try to get the most up to date data.
         */
        let todaysDate = Date().formatted(date: .complete, time: .omitted)
        
        // shouldCheckLastUpdateDate should be true if the viewDidLoad function on the view is triggered
        // This if checks if data was updated today and if the program should care and if so then do not
        // update the data and just return
        if shouldCheckLastUpdateDate && self.lastDataUpdateDate == todaysDate {
            return
        }
        self.lastDataUpdateDate = todaysDate
        guard let resultsController = resultsController else {
            return
        }
        eventsRepository.fetchNewEvents(eventResultsController: resultsController) { events in
            guard events != nil else {
                print("No Events were returned from the events repository fetchNewEvents method")
                return
            }
        }
    }
    // Takes the model and uses that data to fill in the values for this view controller.
    func fillData() {
        // First, clear out existing data
        eventsInADay = []
        
        // Formulate each events date to the day, month, year the event is on into a string
        // Create a grouping of events for each day
        // Fill the dates and events arrays with data
        var compareDateString: String = ""
        for event in allEvents {
            let currDateString: String = event.start!.formatted(date: .abbreviated, time: .omitted)
            // If the last date we save is not the same as the current date, then start a new day
            if compareDateString != currDateString {
                eventsInADay.append(EventsViewModelDay(dateString: currDateString))
                compareDateString = currDateString
            }
            eventsInADay.last!.events.append(EventsViewModelEvent(event: event))
        }
    }
}
