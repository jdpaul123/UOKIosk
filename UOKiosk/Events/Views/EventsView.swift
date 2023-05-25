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
    @State private var loading = false

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
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
                ForEach(viewModel.eventsGroupedByDays) { eventsInADay in
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
                if loading { return }
                loading = true
                defer { loading = false }
                if !didLoad {
                    didLoad = true
                    // TODO: Bug #2 Step 1 On fresh install this task failed when pulling to refresh even with the guarding code in this file to stop refreshing from working
                    await viewModel.fetchEvents(shouldCheckLastUpdateDate: true)
                }
            }
            /*
            .refreshable {
                if loading { return }
                loading = true
                defer { loading = false }
                // TODO: Bug #1 Step 1 when viewModel.fetchEvents() is called while the .task to fetchEvents(shouldCheckLastUpdateDate: true) is still running
                await viewModel.fetchEvents()
            }
             */
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
