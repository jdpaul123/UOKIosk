//
//  TabMenuView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI


struct TabMenuView: View {
    enum Tabs: String {
        /*
         Used to set the starting tab.
         It can also be used for determining the navigation titles if the entire view is in a navigation view
         Instead there is a navigation view for every tab on its own because doing it for the entire view can
         casue unexpected behavior with the state of the navigation title basing itself on the state of one of
         the tabs navigation titles
         */
        case events = "Events"
        case facilityhours = "What's Open"
        case campusMap = "Campus Map"
        case radio = "KWVA Radio"
        case news = "The Daily Emerald"
    }
    
    // TODO: Make view factory as an environment variable so that I don't have to pass around the injector
    let injector: Injector
    @State var selectedTab: Tabs = .events
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                EventsView(injector: injector)
                    .navigationTitle("Events")
            }
            .tag(Tabs.events)
            .tabItem {
                Image(systemName: "calendar")
                Text("Events")
            }
        }
    }
}

#if DEBUG
struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView(injector: Injector(eventsRepository: EventsService(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100")))
    }
}
#endif
