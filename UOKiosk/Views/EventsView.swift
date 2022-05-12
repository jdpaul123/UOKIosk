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
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventListItemView(event: event)
                }
            }
        }
        .task {
            await getEvents()
        }
        .refreshable {
            // Clear the list first
            injector.events = []
            // Get the updated items
            await getEvents()
        }
        .navigationTitle("Events")
    }
    
    func getEvents() async {
        do {
            let data = try await APIService.fetchEventsJSON(urlString: "https://calendar.uoregon.edu/api/2/events?page=1")
            let events = JSONObjectToEventObject.JSONObjectToEventObject(eventsJSON: data)
            injector.events = events
            for event in events {
                print(event.title)
                print(event.localistURL!)
            }
            print()
        } catch {
            injector.events = Event.sampleEventData
            print("Data failed to load")
        }
        
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
