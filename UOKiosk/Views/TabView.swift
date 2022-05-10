//
//  ContentView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

struct TabOptionsView: View {
    @StateObject var injector: Injector
    
    var body: some View {
        TabView {
            
            EventsView(injector: injector)
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
        TabOptionsView(injector: Injector())
            .previewDevice("iPhone 11")
    }
}
