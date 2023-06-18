//
//  EventsListCellViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine

class EventsListCellViewModel: ObservableObject {
    @Published var imageData: Data?
    @Published var title: String

    var cancellables = Set<AnyCancellable>()

    init(event: IMEvent) {
        self.imageData = event.photoData
        self.title = event.title
        subscribeImageDataToEvent(event: event)
    }

    func subscribeImageDataToEvent(event: IMEvent) {
        event.$photoData
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully got image data for Event Cell for event: \(event.title)")
                case .failure(let error):
                    print("Failed to get image data for Event Cell for event: \(event.title)\nWith Error: \(error.localizedDescription)")
                }
                self.cancellables.removeAll()
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                if let imageData = data {
                    self.imageData = imageData
                }
            }
            .store(in: &cancellables)
    }
}