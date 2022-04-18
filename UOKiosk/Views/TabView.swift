//
//  ContentView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

struct TabOptionsView: View {
    var body: some View {
        TabView {
            EventsView() // Change this to the struct for the view later
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
            FacilityHoursView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Hours")
                }
            CampusMapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Campus Map")
                }
            RadioView()
                .tabItem {
                    Image(systemName: "radio")
                    Text("KWVA")
                }
            NewsView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Daily Emerald")
                }
        }
    }
}

struct TabOptionsVIew_Previews: PreviewProvider {
    static var previews: some View {
        TabOptionsView()
            .previewDevice("iPhone 11")
    }
}
