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
     */
    // MARK: Published Attributes
    @Published var events: [Event]
    
    // MARK: API website url strings
    let eventsAPIURLString = "https://calendar.uoregon.edu/api/2/events?page=1&pp=30" // 100 events max for the page: &pp=100
    
    // MARK: UI Attributes
    let backgroundColor = Color.init(uiColor: .systemGroupedBackground) // Use this for the color behind content
    let secondaryBackgroundColor = Color.init(uiColor: .secondarySystemGroupedBackground) // Use this for content groups in the foreground
    
    // MARK: Initializer
    init() {
        self.events = [] // Will later be filled with events when needed
    }
    
    // Special initialization for off-line testing using sample data
    convenience init(isTesting: Bool) {
        self.init()
        if isTesting {
            self.events = Event.sampleEventData
        }
    }
}


