//
//  ContentView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

struct TabOptionsView: View {
    enum Tabs: String {
        /*
         Used to set the starting tab.
         It can also be used for determining the navigation titles if the entire view is in a navigation view
         Instead there is a navigation view for every tab on its own because doing it for the entire view can
         casue unexpected behavior with the state of the navigation title basing itself on the state of one of
         the tabs navigation titles
         */
        case events = "events"
        case facilityhours = "facility hours"
        case campusMap = "campus map"
        case radio = "radio"
        case news = "news"
    }
    @StateObject var injector: Injector
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
            NavigationView {
                FacilityHoursView()
                    .navigationTitle("Facility Hours")
            }
            .tag(Tabs.facilityhours)
            .tabItem {
                Image(systemName: "cart")
                Text("Hours")
            }
            NavigationView {
                CampusMapView()
                    .navigationTitle("Map")
            }
            .tag(Tabs.campusMap)
            .tabItem {
                Image(systemName: "map")
                Text("Campus Map")
            }
            NavigationView {
                RadioView()
                    .navigationTitle("Radio")
            }
            .tag(Tabs.radio)
            .tabItem {
                Image(systemName: "radio")
                Text("KWVA")
            }
            NavigationView {
                NewsView()
                    .navigationTitle("News")
            }
            .tag(Tabs.news)
            .tabItem {
                Image(systemName: "newspaper")
                Text("Daily Emerald")
            }
        }
    }
}


struct TabOptionsVIew_Previews: PreviewProvider {
    static var previews: some View {
        TabOptionsView(injector: Injector())
            .previewDevice("iPhone 11")
    }
}
