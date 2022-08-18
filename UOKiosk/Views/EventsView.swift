//
//  EventsView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation
import SwiftUI

struct EventsView: View {
    let injector: Injector
    @StateObject var viewModel: EventsViewModel
    @State private var didLoad = false
    
    // MARK: INITIALIZERS
    init(injector: Injector) {
        self.injector = injector
        _viewModel = StateObject(wrappedValue: injector.viewModelFactory.makeEmptyEventsViewModel())
    }
    
    var body: some View {
        List {
            ForEach(viewModel.eventsInADay) { eventsInADay in
                Section {
                    ForEach(eventsInADay.events) { event in
                        NavigationLink {
                            EventDetailView(event.eventModel, injector: self.injector)
                        } label: {
                            EventListItemView(event: event)
                        }
                    }
                } header: {
                    Text("\(eventsInADay.dateString)")
                        .font(.title)
                }
            }
        }
        .onAppear {
            if !didLoad {
                didLoad = true
                injector.viewModelFactory.fillEventsViewModel(eventsViewModel: viewModel)
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(injector: Injector(eventsRepository: MockEventsService()))
    }
}

