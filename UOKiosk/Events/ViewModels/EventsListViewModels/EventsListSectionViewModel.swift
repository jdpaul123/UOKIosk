//
//  EventsListSectionViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine
import Collections

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
        dateFormatter.timeStyle = .none
        self.displayDateString = dateFormatter.string(from: dateToDisplay)

        self.events = []
        setUpEventsSink(parentViewModel, dateToDisplay: dateToDisplay)
    }

    func setUpEventsSink(_ parentViewModel: EventsListViewModel, dateToDisplay: Date) {
        parentViewModel.$eventDictionary
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { eventsDictionary in
                self.events = eventsDictionary[dateToDisplay] ?? []
            }
            .store(in: &cancellables)
    }
}
