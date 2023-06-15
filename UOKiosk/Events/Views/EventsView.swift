//
//  EventsView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//
/*
 Button("Customize Feed") {
     showCustomizeFeedView = true
 }.sheet(isPresented: $showCustomizeFeedView) {
     CustomizeEventsFeedView(vm: injector.viewModelFactory.makeCustomizeEventsFeedViewModel())
 */

import SwiftUI
import FirebaseAnalyticsSwift

struct EventsView: View {
    let injector: Injector
    @StateObject var viewModel: EventsViewModel
    @State private var didLoad = false
    @State private var showCustomizeFeedView = false
    @State private var isLoading = false
    @State private var showLoading = false

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        _viewModel = StateObject(wrappedValue: injector.viewModelFactory.makeEventsViewModel())
    }

    var body: some View {
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
            .overlay(content: {
                if showLoading {
                    ProgressView()
                        .scaleEffect(2)
                }
            })
            .task {
                if isLoading { return }
                isLoading = true
                showLoading = true
                defer {
                    isLoading = false
                    showLoading = false
                }
                if !didLoad {
                    didLoad = true
                    await viewModel.fetchEvents(shouldCheckLastUpdateDate: true, toggleLoadingIndicator: true)
                }
            }
            .refreshable {
                if isLoading { return }
                isLoading = true
                defer { isLoading = false }
                await viewModel.fetchEvents()
            }
        .analyticsScreen(name: "\(EventsView.self)")
    }
}

#if DEBUG
struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(injector: Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService()))
    }
}
#endif
