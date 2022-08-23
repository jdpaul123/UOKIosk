//
//  EventsViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/23/22.
//

import Foundation
final class EventsViewModel: ObservableObject, Identifiable {
    /*
     Contains all of the data for the Events View to display
     */
    
    // MARK: Properties
    let id: String = UUID().uuidString
    @Published var eventsInADay: [EventsViewModelDay]
    @Published var lastDataUpdateDate: String {
        didSet {
            // Save the day date that the data is updated to compare with the date on subsiquent application boot ups.
            UserDefaults.standard.set(lastDataUpdateDate, forKey: "lastDataUpdateDate")
        }
    }
    private let eventsRepository: EventsRepository
    
    
    // MARK: Methods
    func fillData(eventsModel: EventsModel) {
        // Formulate each events date to the day, month, year the event is on into a string
        // Create a grouping of events for each day
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.dateFormat = "EEEE, MMM d" // Example: Sunday, Jun 5
        
        // Fill the dates and events arrays with data
        var compareDateString: String = ""
        for event in eventsModel.events {
            let currDateString: String = dayMonthFormatter.string(from: event.start)
            if compareDateString != currDateString {
                eventsInADay.append(EventsViewModelDay(dateString: currDateString))
                compareDateString = currDateString
            }
            eventsInADay.last!.events.append(EventsViewModelEvent(event: event))
        }
    }
    
    // MARK: Initialization
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
        self.eventsInADay = []
        // Check if the lastDataUpdateDate is not the same day as today
        // If the app has never been opened and loaded data, then the last date is "" which will not equal the current
        // date, so it will trigger the data loading method
        self.lastDataUpdateDate = UserDefaults.standard.object(forKey: "lastDataUpdateDate") as? String ?? ""
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
        
        if shouldCheckLastUpdateDate && self.lastDataUpdateDate == todaysDate {
            return
        }
        self.lastDataUpdateDate = todaysDate
        
        eventsRepository.fetchEvents { (eventsModel: EventsModel?) in
            guard let eventsModel = eventsModel else {
                fatalError("Could not get events model")
            }
            // The view model contains data shown on the view so update it on the main thread
            DispatchQueue.main.async {
                self.fillData(eventsModel: eventsModel)
            }
        }
    }
}
