//
//  IMEvent.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine

// IM == In-memory
class IMEvent: Identifiable {
    // MARK: Instance properties
    var id: Int
    var cancellables = Set<AnyCancellable>()

    let title: String
    let eventDescription: String
    let locationName: String?
    let roomNumber: String?
    let address: String?
    let status: String?
    let experience: String?
    let eventUrl: URL?
    let streamUrl: URL?
    let ticketUrl: URL?
    let venueUrl: URL?
    let calendarUrl: URL?
    let photoUrl: URL?
    @Published var photoData: Data?
    let ticketCost: String?
    let start: Date
    let end: Date?
    let allDay: Bool
    var eventLocation: IMEventLocation?
    var departmentFilters: [IMEventFilter]
    var targetAudienceFilters: [IMEventFilter]
    var eventTypeFilters: [IMEventFilter]

    init(id: Int, title: String, eventDescription: String, locationName: String?, roomNumber: String?, address: String?, status: String?, experience: String?, eventUrl: URL?, streamUrl: URL?, ticketUrl: URL?, venueUrl: URL?, calendarUrl: URL?, photoUrl: URL?, photoData: Data?, ticketCost: String?, start: Date, end: Date?, allDay: Bool, eventLocation: IMEventLocation? = nil, departmentFilters: [IMEventFilter], targetAudienceFilters: [IMEventFilter], eventTypeFilters: [IMEventFilter]) {
        self.id = id
        self.title = title
        self.eventDescription = eventDescription
        self.locationName = locationName
        self.roomNumber = roomNumber
        self.address = address
        self.status = status
        self.experience = experience
        self.eventUrl = eventUrl
        self.streamUrl = streamUrl
        self.ticketUrl = ticketUrl
        self.venueUrl = venueUrl
        self.calendarUrl = calendarUrl
        self.photoUrl = photoUrl
        self.photoData = photoData
        self.ticketCost = ticketCost
        self.start = start
        self.end = end
        self.allDay = allDay
        self.eventLocation = eventLocation
        self.departmentFilters = departmentFilters
        self.targetAudienceFilters = targetAudienceFilters
        self.eventTypeFilters = eventTypeFilters
        getImage()
    }

    func getImage() {
        guard let photoUrl = photoUrl else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: photoUrl)
            .sink { completion in
                // TODO: Add error handling
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("!!! Failed to get photo for event, \(self.title), with error: \(error.localizedDescription)")
                }
                self.cancellables.removeAll()
            } receiveValue: { [weak self] (data, respose) in
                self?.photoData = data
            }
            .store(in: &cancellables)
    }
}
