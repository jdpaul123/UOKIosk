//
//  EventsUI.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

struct EventsView: View {
    
    @ObservedObject var injector: Injector
    //@State var eventsLoaded: Bool = false
    
    var body: some View {
        List {
            ForEach(injector.events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventListItemView(event: event)
                }
            }
        }
        .task {
            // Only update events on task if we have not loaded in events yet
            // The user will refresh if they want to see if events need updating
            if injector.events.isEmpty {
                await fillEvents(reloadEvents: false)
            } else {
                await fillEvents(reloadEvents: true)
            }
            
        }
        .refreshable {
            await fillEvents(reloadEvents: false)
        }
    }

    func fillEvents(reloadEvents: Bool) async {
        // Save the events in the case of a failure
        let savedEvents = injector.events
        // Clear the list first
        injector.events = []
        // Get the updated items
        if !reloadEvents {
            guard await getEvents() else {
                injector.events = savedEvents
                print("Could not get the new events please retry")
                return
            }
        } else {
            injector.events = savedEvents
        }
    }
    
    func getEvents() async -> Bool {
        /*
         Returns true if the Event Getting was a success
         */
        /*
        var eventles: [Event] = []
        await APIService.fetchJSON(urlString: injector.eventsAPIURLString) { (eventsFromAPI: EventsSearchFromAPI?, response) in
            if let eventsFromAPI = eventsFromAPI {
                eventles = JSONObjectToEventObject.JSONObjectToEventObject(eventsJSON: eventsFromAPI)
            } else {
                print("Data failed to load correctoly from API with response: \(response)")
                eventles = Event.sampleEventData
            }
        }
        return eventles
         */
        
        guard let data = try? await APIService.fetchEventsJSON(urlString: injector.eventsAPIURLString) else {
            injector.events = Event.sampleEventData
            print("Data failed to load")
            return false
        }
        let events = JSONObjectToEventObject.JSONObjectToEventObject(eventsJSON: data)
        injector.events = events
        return true
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            EventsView(injector: Injector(isTesting: true))
        }
        .previewDevice("iPhone 12")
        .previewInterfaceOrientation(.portrait)
            
    }
}
