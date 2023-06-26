//
//  EventsListSectionViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine

class EventsListSectionViewModel: ObservableObject, Identifiable {
    let id = UUID()

    var cancellables = Set<AnyCancellable>()
    let date: Date
    let displayDateString: String
    @Published var events: [Event]

    init(parentViewModel: EventsListViewModel, dateToDisplay: Date) {
        self.date = dateToDisplay

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        self.displayDateString = dateFormatter.string(from: dateToDisplay)

        self.events = []
        setUpEventsSink(parentViewModel, dateToDisplay: dateToDisplay)
    }

    func setUpEventsSink(_ parentViewModel: EventsListViewModel, dateToDisplay: Date) {
        parentViewModel.$eventsDictionary
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("!!! Finished Successfully")
                case .failure(let error):
                    print("!!! Error with the eventsDictionary Sync: \(error.localizedDescription)")
                }
                self.cancellables.removeAll()
            } receiveValue: { [ weak self ] eventsDictionary in
                    self?.events = eventsDictionary[dateToDisplay] ?? []
            }
            .store(in: &cancellables)
    }
}
