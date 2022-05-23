//
//  EventsUI.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

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
            if !eventsLoaded {
                eventsLoaded = true
                await getEvents()
            }
        }
        .refreshable {
            // Clear the list first
            injector.events = []
            // Get the updated items
            await getEvents()
        }
    }

    
    func getEvents() async {
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
            return
        }
        let events = JSONObjectToEventObject.JSONObjectToEventObject(eventsJSON: data)
        injector.events = events
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
