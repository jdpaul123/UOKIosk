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
        case whatIsOpen = "What's Open"
        case campusMap = "Campus Map"
        case radio = "KWVA Radio"
        case news = "The Daily Emerald"

        var sfSymbol: String {
            switch self {
            case .events:
                return "calendar"
            case .whatIsOpen:
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
            // StackNavigationViewStyle() causes logging bug where this log is shown when a list item is tapped: 2023-05-25 14:53:13.416096-0700 UOKiosk[3825:1682743] [API] Failed to create 0x88 image slot (alpha=1 wide=1) (client=0xc554bbe2) [0x5 (os/kern) failure]
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.events)
            .tabItem {
                Image(systemName: Tabs.events.sfSymbol)
                Text(Tabs.events.rawValue)
            }

            NavigationView {
                WhatIsOpenView(injector: injector)
                    .navigationTitle("What's Open")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.whatIsOpen)
            .tabItem {
                Image(systemName: Tabs.whatIsOpen.sfSymbol)
                Text(Tabs.whatIsOpen.rawValue)
            }
        }
    }
}

#if DEBUG
struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Pass in dummy data for this
        TabMenuView(injector: Injector(eventsRepository: EventsService(urlString: "https://calendar.uoregon.edu/api/2/events?days=90&recurring=false&pp=100"),
                                       whatIsOpenRepository: WhatIsOpenService(urlString: "https://api.woosmap.com/stores/search/?private_key=cd319766-0df2-4135-bf2a-0a1ee3ad9a6d")))
    }
}
#endif
