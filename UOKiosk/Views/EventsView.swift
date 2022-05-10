//
//  EventsUI.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//
/*
 Top down structure:
 // Search bar
 // Filter button
 // Date
 // List
 // Date
 // List
 */


import SwiftUI

struct EventsView: View {
    @ObservedObject var injector: Injector
    @State var eventsLoaded: Bool = false
    
    var body: some View {
        List {
            ForEach(injector.events) { event in
                NavigationLink(destination: EventDetailView()) {
                    EventListItemView(event: event)
                }
            }
        }
        .refreshable {
            do {
                let data = try await APIService.fetch(urlString: "https://calendar.uoregon.edu/api/2/events?page=1")
                for event in data.events {
                    print(event.event.locationName ?? "No location name")
                    injector.events.append(event.event)
                }
                print()
            } catch {
                injector.events = Injector.sampleEventData
                print("Data failed to load")
            }
        }
        .navigationTitle("Events")
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            EventsView(injector: Injector())
        }
        .previewDevice("iPhone 12")
        .previewInterfaceOrientation(.portrait)
            
    }
}
