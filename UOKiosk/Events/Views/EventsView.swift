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
    @StateObject var vm: EventsViewModel
    @State private var showCustomizeFeedView = false

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeEventsViewModel())
    }

    var body: some View {
            List {
                ForEach(vm.eventsGroupedByDays) { eventsInADay in
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
                if vm.showLoading {
                    ProgressView()
                        .scaleEffect(2)
                }
            })
            .task {
                if vm.isLoading { return }
                vm.isLoading = true
                defer { vm.isLoading = false }
                if !vm.didLoad {
                    vm.didLoad = true
                    await vm.fetchEvents(shouldCheckLastUpdateDate: true, toggleLoadingIndicator: true)
                }
            }
            .refreshable {
                if vm.isLoading { return }
                vm.isLoading = true
                defer { vm.isLoading = false }
                await vm.fetchEvents()
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
