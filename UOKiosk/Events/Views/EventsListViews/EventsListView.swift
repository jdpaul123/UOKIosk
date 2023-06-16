//
//  EventsListView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import SwiftUI

struct EventsListView: View {
    let injector: Injector
    @StateObject var vm: EventsListViewModel

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeEventsListViewModel())
    }

    var body: some View {
        List {
            ForEach(vm.eventDictionary.keys, id: \.description) { dateToDisplay in
                EventsListSectionView(injector: injector, parentViewModel: self.vm, dateToDisplay: dateToDisplay)
            }
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(injector: Injector(eventsRepository: MockEventsService(),
                                          whatIsOpenRepository: MockWhatIsOpenService()))
    }
}
