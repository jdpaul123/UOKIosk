//  UOKioskApp.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI

@main
struct UOKioskApp: App {
    // FIXME: This url does not show recurring events. Add an option for allowing recurring events in a settings page on the app
    let injector = Injector(eventsRepository: EventsService(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"))

    var body: some Scene {
        WindowGroup {
            TabMenuView(injector: injector)
        }
    }
}
