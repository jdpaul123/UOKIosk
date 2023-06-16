//
//  EventsListSectionView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import SwiftUI

struct EventsListSectionView: View {
    let injector: Injector
    @StateObject var vm: EventsListSectionViewModel

    // MARK: INITIALIZER
    init(injector: Injector, parentViewModel: EventsListViewModel, dateToDisplay: Date) {
        self.injector = injector
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeEventsListSectionViewModel(parentViewModel: parentViewModel, dateToDisplay: dateToDisplay))
    }

    var body: some View {
        Section {
            ForEach(vm.events) { event in
                NavigationLink {
                    EventDetailView(event, injector: injector)
                } label: {
                    EventsListCellView(injector: injector, imageData: event.photoData ?? Data(), title: event.title ?? "No Title")
                }
            }
        } header: {
            Text("\(vm.displayDateString)")
                .font(.title)
        }
    }
}

struct EventsListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let injector = Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService())
        EventsListSectionView(injector: injector, parentViewModel: injector.viewModelFactory.makeEventsListViewModel(), dateToDisplay: Date())
    }
}
