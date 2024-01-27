//
//  EventsListCellViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class EventsListCellViewModel: ObservableObject {
    @Published var event: Event
    @Published var image: Image = Image(.no)
    var imageSubscription: AnyCancellable? = nil
    let title: String

    init(event: Event) {
        self.event = event
        self.title = event.title
        if let data = event.photoData, let uiImage = UIImage(data: data) {
            self.image = Image(uiImage: uiImage)
        }
        subscribeImageDataToEvent(event: event)
    }

    func subscribeImageDataToEvent(event: Event) {
        imageSubscription = event.$imPhotoData
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("!!! Finished subscribeImageDataToEvent(event:)")
                    break
                case .failure(let error):
                    print("!!! Failed to get image data for Event Cell for event, \(event.title), with Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                if let data, let uiImage = UIImage(data: data) {
                    self.image = Image(uiImage: uiImage)
                }
            }
    }
}
