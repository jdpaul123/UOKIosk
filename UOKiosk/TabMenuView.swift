//
//  TabMenuView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI

enum Tabs: String {
    case events = "Events"
    case whatIsOpen = "What's Open"
    case campusMap = "Campus Map"
    case radio = "School Radio"
    case news = "School News"

    var sfSymbol: String {
        switch self {
        case .events:
            return "calendar"
        case .whatIsOpen:
            return "hourglass"
        case .campusMap:
            return "map"
        case .news:
            return "newspaper"
        case .radio:
            return "radio"
        }
    }
}

struct TabMenuView: View {
    @State var selectedTab: Tabs = .events
    @EnvironmentObject var injector: Injector
    @EnvironmentObject var themeService: ThemeService

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                EventsListView(vm: injector.viewModelFactory.makeEventsListViewModel())
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
                DiningHoursView(vm: injector.viewModelFactory.makeWhatIsOpenViewModel(type: .dining))
                    .navigationTitle(Tabs.whatIsOpen.rawValue)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.whatIsOpen)
            .tabItem {
                Image(systemName: Tabs.whatIsOpen.sfSymbol)
                Text(Tabs.whatIsOpen.rawValue)
            }

            NavigationView {
                CampusMapView(vm: injector.viewModelFactory.makeCampusMapViewModel())
                    .navigationTitle(Tabs.campusMap.rawValue)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.campusMap)
            .tabItem {
                Image(systemName: Tabs.campusMap.sfSymbol)
                Text(Tabs.campusMap.rawValue)
            }

            NavigationView {
                NewsFeedView(vm: injector.viewModelFactory.makeNewsFeedViewModel())
                    .navigationTitle(Tabs.news.rawValue)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.news)
            .tabItem {
                Image(systemName: Tabs.news.sfSymbol)
                Text(Tabs.news.rawValue)
            }

            NavigationView {
                RadioView(vm: injector.viewModelFactory.makeRadioViewModel())
                    .navigationTitle(Tabs.radio.rawValue)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(Tabs.radio)
            .tabItem {
                Image(systemName: Tabs.radio.sfSymbol)
                Text(Tabs.radio.rawValue)
            }
        }
        .tint(themeService.selectedTheme.secondaryColor)
    }
}

#if DEBUG
struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Pass in dummy data for this
        TabMenuView()
            .environmentObject(Injector())
    }
}
#endif
