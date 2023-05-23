//
//  EventsView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct EventsView: View {
    let injector: Injector
    @StateObject var viewModel: EventsViewModel
    @State private var didLoad = false
    @State private var showCustomizeFeedView = false
    
    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        // Set the var StateObject<EventsViewModel>
        _viewModel = StateObject(wrappedValue: injector.viewModelFactory.makeEventsViewModel())
    }

    var body: some View {
        VStack {
//            Button("Customize Feed") {
//                showCustomizeFeedView = true
//            }.sheet(isPresented: $showCustomizeFeedView) {
//                CustomizeEventsFeedView(vm: injector.viewModelFactory.makeCustomizeEventsFeedViewModel())
//            }
            List {
                ForEach(viewModel.eventsInADay) { eventsInADay in
                    Section {
                        ForEach(eventsInADay.events) { event in
                            NavigationLink {
                                EventDetailView(event.eventModel, injector: self.injector)
                            } label: {
                                EventCellView(event: event)
                            }
                        }
                    } header: {
                        Text("\(eventsInADay.dateString)")
                            .font(.title)
                    }
                }
            }
            .task {
                if !didLoad {
                    didLoad = true
                    await viewModel.fetchEvents(shouldCheckLastUpdateDate: true)
                }
            }
            .refreshable {
                await viewModel.fetchEvents()
            }
        }
        .analyticsScreen(name: "\(EventsView.self)")
    }
}

#if DEBUG
struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(injector: Injector(eventsRepository: MockEventsService()))
    }
}
#endif