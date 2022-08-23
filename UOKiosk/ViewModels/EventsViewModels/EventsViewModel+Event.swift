//
//  EventsViewModel+Event.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/23/22.
//

import Foundation
import UIKit

final class EventsViewModelEvent: ObservableObject, Identifiable, Hashable {
    // MARK: Properties
    let eventModel: EventModel

    let id: String = UUID().uuidString
    @Published var image: UIImage
    @Published var title: String
    @Published var date: Date
    @Published var dateString: String
    
    // MARK: Equitable for Identifiable
    static func == (lhs: EventsViewModelEvent, rhs: EventsViewModelEvent) -> Bool {
        return lhs.id == rhs.id && lhs.image == rhs.image && lhs.title == rhs.title
    }
    
    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(title)
    }
    
    // MARK: Initializers
    init(event: EventModel) {
        self.eventModel = event
        
        self.title = event.title
        // Try to get the image and if there is none use the image that shows the event has no image
        self.image = UIImage.init(data: event.photoData!) ?? UIImage.init(named: "NoImage")!
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        self.dateString = dateFormatter.string(from: event.start)
        self.date = event.start
    }
}
