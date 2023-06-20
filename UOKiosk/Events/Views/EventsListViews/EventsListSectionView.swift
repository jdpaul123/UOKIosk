//
//  EventsListSectionView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import SwiftUI

struct EventsListSectionView: View {
    @EnvironmentObject var injector: Injector
    @StateObject var vm: EventsListSectionViewModel

    // MARK: INITIALIZER
    init(vm: EventsListSectionViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        Section {
            ForEach(vm.events) { event in
                NavigationLink {
                    EventDetailView(vm: injector.viewModelFactory.makeEventDetailViewModel(eventModel: event))
                } label: {
                    EventsListCellView(vm: injector.viewModelFactory.makeEventsListCellViewModel(event: event))
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
        let cal = Calendar(identifier: .gregorian)
        let day = cal.component(.day, from: Date())
        let month = cal.component(.month, from: Date())
        let year = cal.component(.year, from: Date())
        let dateToDisplay = cal.date(from: DateComponents(year: year, month: month, day: day))!
        EventsListSectionView(vm: injector.viewModelFactory.makeEventsListSectionViewModel(parentViewModel: EventsListViewModel(eventsRepository: injector.eventsRepository), dateToDisplay: dateToDisplay))
    }
}
