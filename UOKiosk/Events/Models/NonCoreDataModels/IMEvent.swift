//
//  IMEvent.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import Combine

// IM == In-memory
// Check == The attribute also exists in the Event core data object
class IMEvent: Identifiable {
    // MARK: Instance properties
    var id: Int // Check
    var cancellables = Set<AnyCancellable>()

    let title: String // Check
    let eventDescription: String // Check
    let locationName: String? // Check
    let roomNumber: String? // Check
    let address: String? // Check
    let status: String? // Check
    let experience: String? // Check
    let eventUrl: URL? // Check
    let streamUrl: URL? // Check
    let ticketUrl: URL? // Check
    let venueUrl: URL? // Check
    let calendarUrl: URL? // Check
    let photoUrl: URL?
    @Published var photoData: Data? // Check
    let ticketCost: String? // Check
    let start: Date // Check
    let end: Date? // Check
    let allDay: Bool // Check
    var eventLocation: IMEventLocation? // Check
    var departmentFilters: [IMEventFilter] // Check
    var targetAudienceFilters: [IMEventFilter] // Check
    var eventTypeFilters: [IMEventFilter] // Check

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
