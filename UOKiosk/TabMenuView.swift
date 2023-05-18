//
//  TabMenuView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI


struct TabMenuView: View {
    enum Tabs: String {
        case events = "Events"
        case facilityhours = "What's Open"
        case campusMap = "Campus Map"
        case radio = "KWVA Radio"
        case news = "The Daily Emerald"

        var sfSymbol: String {
            switch self {
            case .events:
                return "calendar"
            case .facilityhours:
                return "hourglass"
            default:
                return "dot.square"
            }
        }
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
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.events)
            .tabItem {
                Image(systemName: Tabs.events.sfSymbol)
                Text(Tabs.events.rawValue)
            }
            NavigationView {
                FacilityHoursView()
            }
            .tag(Tabs.facilityhours)
            .tabItem {
                Image(systemName: Tabs.facilityhours.sfSymbol)
                Text(Tabs.facilityhours.rawValue)
            }
        }
    }
}

#if DEBUG
struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Pass in dummy data for this
        TabMenuView(injector: Injector(eventsRepository: EventsService(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100")))
    }
}
#endif
