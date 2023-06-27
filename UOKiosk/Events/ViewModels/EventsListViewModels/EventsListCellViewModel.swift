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
    @Published var photoData: Data
    var photoSubscription: AnyCancellable? = nil
    let title: String

    init(event: Event) {
        self.event = event
        self.title = event.title
        let noImageData: Data = UIImage(named: "NoImage")!.pngData()!
        photoData = event.photoData ?? noImageData
        setUpPhotoSubscription(event: event)
    }

    func setUpPhotoSubscription(event: Event) {
        self.photoSubscription = Timer
            .publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if let updatedPhotoData = event.photoData, updatedPhotoData != UIImage(named: "NoImage")!.pngData()! {
                    self?.photoData = updatedPhotoData
                    self?.photoSubscription?.cancel()
                }
            }
//        self.photoSubscriber = $event
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("!!! Finished EventsListCellViewModel init sink for \(event.title)")
//                    break
//                case .failure(let error):
//                    print("!!! Failed to get photo for event detail view, \(event.title), with error: \(error.localizedDescription)")
//                }
//            } receiveValue: { [weak self] data in
//                if let photoData = data.photoData {
//                    print("!!! Setting photo to nil photo: \(photoData != UIImage(named: "NoImage")!.pngData()!)")
//                    self?.photoData = photoData
//                }
//            }
    }
}
