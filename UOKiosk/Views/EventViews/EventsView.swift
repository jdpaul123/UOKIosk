//
//  EventsUI.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

struct EventsView: View {
   
    
    init(injector: Injector) {
        self.injector = injector
        monthFormatter.dateFormat = "EEEE, MMM, d"
    }
    
    @ObservedObject var injector: Injector
    //@State var eventsLoaded: Bool = false
    
    var body: some View {
        List {
            var index = 0
            var prev = ""
            while index < injector.events.count {
                Section(header: Text(monthFormatter.string(from: injector.events[index].startDate))) {
                    for event in index..<injector.events.count {
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventListItemView(event: event)
                        }
                        index += 1
                    }
                }
            }
            /*
             ForEach(injector.events) { event in
                Section(header: Text(monthFormatter.string(from: event.startDate))) {
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventListItemView(event: event)
                    }
                }
                .font(.headline)
             }
             */
        }
        .task {
            // Only update events on task if we have not loaded in events yet
            // The user will refresh if they want to see if events need updating
            if injector.events.isEmpty {
                await fillEvents(reloadEvents: true)
            } else {
                await fillEvents(reloadEvents: false)
            }
            
        }
        .refreshable {
            await fillEvents(reloadEvents: true)
        }
    }

    func fillEvents(reloadEvents: Bool) async {
        // Save the events in the case of a failure
        let savedEvents = injector.eventsViewModel
        // Clear the list first
        injector.eventsViewModel = []
        // Get the updated items
        if reloadEvents {
            guard await getEvents() else {
                injector.eventsViewModel = savedEvents
                print("Could not get the new events please retry")
                return
            }
            print("Loaded up to date events")
        } else {
            injector.events = savedEvents
        }
    }
    
    func getEvents() async -> Bool {
        /*
         Returns true if the Event Getting was a success
         */
        guard let data: EventsModel = try? await APIService.fetchJSON(urlString: injector.eventsAPIURLString) else {
            injector.events = EventsModel.sampleEventData
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
