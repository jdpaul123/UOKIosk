//
//  EventsListCellViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine
import SwiftUI

class EventsListCellViewModel: ObservableObject {
    @Published var event: Event
    @Published var imageData: Data
    var imageSubscription: AnyCancellable? = nil
    let title: String

    init(event: Event) {
        self.event = event
        self.title = event.title
        let noImageData: Data = UIImage(named: "NoImage")!.pngData()!
        imageData = event.photoData ?? noImageData
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
                self.imageData = data ?? self.imageData
            }
    }
}
