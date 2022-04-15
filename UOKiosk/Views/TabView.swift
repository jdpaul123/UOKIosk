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
            Text("Events") // Change this to the struct for the view later
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
            Text("Facility Hours")
                .tabItem {
                    Image(systemName: "cart")
                    Text("Hours")
                }
            Text("Campus Map")
                .tabItem {
                    Image(systemName: "map")
                    Text("Campus Map")
                }
            Text("KWVA")
                .tabItem {
                    Image(systemName: "radio")
                    Text("KWVA")
                }
            Text("Daily Emerald")
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
    }
}
