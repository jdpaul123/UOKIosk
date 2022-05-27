//
//  Dependency.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

import SwiftUI

class Injector: ObservableObject {
    /*
     Location of instantiation for all dependency creation for the program
     
     Data-related attributes are optionals becasue they hold nil values until the view calls it's setup method on the injector
     */
    //MARK: Attributes
    private var eventsModel: EventsModel = EventsModel(eventModelMiddleLayer: [])
    
    // MARK: Published Attributes
    @Published var eventsViewModel: [[EventViewModel]] = [] // Lists are split by the day date of the events.
    
    // MARK: API website url strings
    // Below is the default filtering. Always call for 90 days in the future. Get the first 100 items
    // Then don't show events that are recurring.
    // TODO build the url for searching based on a users filter options
    let eventsAPIURLString = "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100" // 100 events max for the page: &pp=100
    
    // MARK: UI Attributes
    let backgroundColor = Color.init(uiColor: .systemGroupedBackground) // Use this for the color behind content
    let secondaryBackgroundColor = Color.init(uiColor: .secondarySystemGroupedBackground) // Use this for content groups in the foreground
    
    // MARK: Initializers
    init() {
    }
    
    // MARK: ViewModel Setup Methods
    func setUpEvents() {
        /*
         Input: None
         Return: Void
         Side Effect: Fills the eventsModel parameter with an array of EventMiddleLayer type objects
         
         This is used to return the view model for the events stack of views. It will be passed around as a state variable for the views
         contained in the events stack.
         
         It's basic sequence of jobs are as follows:
            1. Call the api to get the events from Localist API and set it to private events value
            2. Throw an error if the data fails to load
            3. Instantiate the Events View Model by passing it the recieved Events
         */
        
        
        // Get the JSON Events model
        Task {
            // TODO make this url the correct value based on the user defaults values for filters. Default filiter is to filter out recurring events
            await APIService.fetchJSON(urlString: eventsAPIURLString, completion: { (eventsModelSearchResults: EventsModel?) in
                guard let eventsModelSearchResults = eventsModelSearchResults else {
                    print("Above is the error message for this data failure")
                }
                self.eventsModel = eventsModelSearchResults
            })
        }
        
        
        
        
        
    }
    
    // Special initialization for off-line testing and SwiftUI PreviewProvider using sample data
    convenience init(isTesting: Bool) {
        self.init()
        if isTesting {
            self.events = Event.sampleEventData
        }
    }
}


extension Injector {
    
}
