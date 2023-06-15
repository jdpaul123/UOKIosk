//
//  EventsViewModel+Event.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/23/22.
//

import UIKit

final class EventCellViewModel: ObservableObject, Identifiable, Hashable {
    // MARK: Properties
    let eventModel: Event

    let id: String = UUID().uuidString
    @Published var image: UIImage
    @Published var title: String
    @Published var date: Date
    @Published var dateString: String
    
    // MARK: Equitable for Identifiable
    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.image == rhs.image && lhs.title == rhs.title
    }
    
    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(title)
    }
    
    // MARK: Initializers
    init(event: Event) {
        self.eventModel = event
        
        self.title = event.title ?? "No Title"
        // Try to get the image and if there is none use the image that shows the event has no image
        if let photoData = event.photoData {
            self.image = UIImage.init(data: photoData) ?? UIImage.init(named: "NoImage")!
        } else {
            self.image = UIImage.init(named: "NoImage")!
        }
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        if let start = event.start {
            self.dateString = dateFormatter.string(from: start)
            self.date = start
        } else {
            // This case should never be hit because any event that does not have a start date is not saved to the CD Persistent Store
            dateString = ""
            self.date = Date(timeIntervalSince1970: 0)
        }
    }
}
