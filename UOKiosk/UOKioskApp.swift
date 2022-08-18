// MARK: THIS VERSION CREATED 8/17/22 just before 11:00 pm
//  UOKioskApp.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI

@main
struct UOKioskApp: App {
    let injector = Injector(eventsRepository: EventsService(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"))
    
    var body: some Scene {
        WindowGroup {
            TabMenuView(injector: injector)
        }
    }
}
