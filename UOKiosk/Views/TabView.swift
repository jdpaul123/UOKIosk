//
//  ContentView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

struct TabOptionsView: View {
    enum Tabs: String {
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
                EventsView(injector: injector)
                    .tag(Tabs.events)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Events")
                    }
                FacilityHoursView()
                    .tag(Tabs.facilityhours)
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Hours")
                    }
                CampusMapView()
                    .tag(Tabs.campusMap)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Campus Map")
                    }
                RadioView()
                    .tag(Tabs.radio)
                    .tabItem {
                        Image(systemName: "radio")
                        Text("KWVA")
                    }
                NewsView()
                    .tag(Tabs.news)
                    .tabItem {
                        Image(systemName: "newspaper")
                        Text("Daily Emerald")
                    }
            }
            .navigationTitle(selectedTab.rawValue.capitalized)
    }
}


struct TabOptionsVIew_Previews: PreviewProvider {
    static var previews: some View {
        TabOptionsView(injector: Injector())
            .previewDevice("iPhone 11")
    }
}
