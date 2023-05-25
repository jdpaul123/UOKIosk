//  UOKioskApp.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct UOKioskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private var eventsUrlString: String
    let injector: Injector

    init() {
        // FIXME: This url does not show recurring events. Add an option for allowing recurring events in a settings page on the app
        // If no data, then set the URL for events to the default: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"
        eventsUrlString = "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100" // TODO: make this customizable based on the filters
        injector = Injector(eventsRepository: EventsService(urlString: eventsUrlString))
    }

    var body: some Scene {
        WindowGroup {
            TabMenuView(injector: injector)
                .environment(\.managedObjectContext, injector.eventsRepository.persistentContainer.viewContext)
        }
    }
}
