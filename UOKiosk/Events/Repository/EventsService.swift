//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import CoreData
import Combine

/*
 The service will decide if it just gets data from the Core Data Persistent Store
 or if it calls the api for fresh data, waits for it, and returns data from the Persistent Store.

 Pull-to-refrehs performs the fetchEvents that is described above but it will call
 the api every time.

 When event data arrives from the API the Data Tranfer Objects for events and the data is transfered to Core Data Event entities. Then the view display the fetched results
 from the Core Data Persistent Store.

 Data Permission:
 https://calendar.uoregon.edu states, "Embed events anywhere on the web with our Widget builder."
 The text that says "Widget builder" is a hyperlink to https://calendar.uoregon.edu/help/widget
 where they state, "Want to put events you find on your own site? Use the widget builder to generate
 a little box you can put wherever you please!". Therefore, anyone has permission to use the data.
 */

class EventsService: EventsRepository {
    enum FilterType {
        case department
        case targetAudience
        case eventType
    }

    enum EventServiceError: Error {
        case locationsEventDoesNotExist

        var errorDescription: String? {
            switch self {
            case .locationsEventDoesNotExist:
                return NSLocalizedString("While adding a Location object to the Core Data store there was no Event found to create a relation to from the Location", comment: "")
            }
        }
    }

    // MARK: Properties
    private let urlString: String
    var persistentContainer: NSPersistentContainer
    private var lastDataUpdateDate: Date {
        didSet {
            // Save the day date that the data is updated to compare with the date on subsiquent application boot ups.
            UserDefaults.standard.set(lastDataUpdateDate, forKey: "lastDataUpdateDate")
        }
    }
    private var isLastUpdatedToday: Bool
    private var cancellables = Set<AnyCancellable>()
    @Published var events: [Event] = [Event]()

    // MARK: Init
    init(urlString: String) {
        self.urlString = urlString
        self.lastDataUpdateDate = UserDefaults.standard.object(forKey: "lastDataUpdateDate") as? Date ?? Date(timeIntervalSince1970: 0)
        self.isLastUpdatedToday = Calendar(identifier: .gregorian).isDateInToday(lastDataUpdateDate)

        persistentContainer = NSPersistentContainer(name: "EventsModel")
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                print("!!! Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
                return
            }

            // TODO: What is NSPersistentHistoryTrackingKey for? Am I actually using it
//            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

            // NSMergeByPropertyObjectTrumpMergePolicy means that any object that is trying to add an Event Object with the same id as one already saved then it only updates the data rather than saving a second copy
            self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    // TODO: Make it so getImage(event:) is only called when fetchFreshEvents() is too so that the method is not called every time the app is run
    @MainActor
    func getImage(event: Event) {
        guard let photoUrl = event.photoUrl else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: photoUrl)
            .sink { completion in
                // TODO: Add error handling
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("!!! Failed to get photo for event, \(event.title), with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] (data, respose) in
                event.photoData = data
                event.imPhotoData = data
                try? self?.saveViewContext()
            }
            .store(in: &cancellables)
    }

    // MARK: Get events (determine if getting saved events or fetching events from REST API then getting saved events)
    @MainActor
    func fetchEvents() async throws -> NSFetchedResultsController<Event>? {
        if !isLastUpdatedToday {
            lastDataUpdateDate = .now
            // call api for fresh data
            do {
                try await fetchFreshEvents()
            } catch {
                throw error
            }
        }

        let resultsController = fetchSavedEvents()
        guard let resultsController = resultsController, let fetchedObjects = resultsController.fetchedObjects,
              !fetchedObjects.isEmpty else {
            // call api for fresh data
            do {
                try await fetchFreshEvents()
            } catch {
                throw error
            }
            return fetchSavedEvents()
        }
        return resultsController
    }

    // MARK: Get Saved Events
    @MainActor
    func fetchSavedEvents() -> NSFetchedResultsController<Event>? {
        let fetchedResultsController = eventResultsController()
        guard let fetchedResultsController = fetchedResultsController, let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return nil
        }

        let cal = Calendar(identifier: .gregorian)
        let nowDay = cal.component(.day, from: .now)
        let nowMonth = cal.component(.month, from: .now)
        let nowYear = cal.component(.year, from: .now)
        let today = cal.date(from: DateComponents(year: nowYear, month: nowMonth, day: nowDay))
        guard let today = today else {
            return fetchedResultsController
        }

        // Delete any events that are before the current date
        for event in fetchedObjects {
            // Delete any events from before today
            if event.start.compare(today) == .orderedAscending {
                try? deleteEvent(event)
            }
        }
        return fetchedResultsController
    }

    // MARK: Get Fresh Events
    @MainActor
    private func fetchFreshEvents() async throws {
        var dto: EventsDto? = nil
        do {
            dto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            throw error
        }

        guard let dto = dto else {
            throw EventsServiceError.dataTransferObjectIsNil
        }

        var eventDtos = [EventDto]()
        // If an event loaded in has an id that does not equate to any of the id's on the events already saved, then add the event to the persistent store
        for middleLayer in dto.eventMiddleLayerDto {
            let eventDto = middleLayer.eventDto
            // Make sure there is date info for the event and that the object has a start date
            guard let eventInstanceWrapper = eventDto.eventInstances?[0], eventInstanceWrapper.eventInstance.start != "" else {
                continue
            }

            let dateValues = getEventInstanceDateData(dateData: eventInstanceWrapper.eventInstance)
            let allDay = dateValues.allDay
            let _ = dateValues.start
            let end = dateValues.end
            if allDay == true {
                // If the event is all day then we should save it
                eventDtos.append(eventDto)
            }
            guard let end = end else {
                // If the event is not all day, but we do not know when it ends, then we should save it
                eventDtos.append(eventDto)
                continue
            }
            if end < Date() {
                // If the event is already over then we should not save it
                continue
            }
            // If the event is not all day, but the end of the event is in the future then save it
            eventDtos.append(eventDto)
        }

        for eventDto in eventDtos {
            guard let eventInstances = eventDto.eventInstances else {
                fatalError("There are no event instances to access")
            }
            let dateData = eventInstances[0].eventInstance
            let dateValues = getEventInstanceDateData(dateData: dateData)

            // Add the event
            let event: Event
            do {
                event = try addEvent(eventDto, start: dateValues.start, end: dateValues.end, allDay: dateValues.allDay)
            } catch {
                throw error
            }

            // Add the relationships to the event
            if let eventTypeFilters = eventDto.filters.eventTypes {
                for eventTypeFilter in eventTypeFilters {
                    do {
                        try addFilter(to: event, filter: eventTypeFilter, filterType: .eventType)
                    } catch {
                        throw error
                    }
                }
            }
            if let departmentFilters = eventDto.filters.departments {
                for departmentFilter in departmentFilters {
                    do {
                        try addFilter(to: event, filter: departmentFilter, filterType: .department)
                    } catch {
                        throw error
                    }
                }
            }
            if let targetAudienceFilters = eventDto.filters.eventTargetAudience {
                for targetAudienceFilter in targetAudienceFilters {
                    do {
                        try addFilter(to: event, filter: targetAudienceFilter, filterType: .targetAudience)
                    } catch {
                        throw error
                    }
                }
            }

            if let geoDto = eventDto.geo {
                do {
                    try addLocation(to: event, geoDto: geoDto)
                } catch {
                    throw error
                }
            }
        }
    }

    private func getEventInstanceDateData(dateData: EventInstanceDto) -> (allDay: Bool, start: Date, end: Date?) {
        let startStr: String = dateData.start
        let endStr: String? = dateData.end

        // Format the start and end dates if they exist
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
        let start: Date
        let end: Date?

        start = {
            guard let date = dateFormatter.date(from: startStr) else {
                fatalError("Start date could not be determined form the provided date string")
            }
            return date
        }()

        if let endStr = endStr {
            end = dateFormatter.date(from: endStr)
        } else {
            end = nil
        }

        let allDay = dateData.allDay
        return (allDay, start, end)
    }

    @MainActor
    private func addEvent(_ eventDto: EventDto, start: Date, end: Date?, allDay: Bool) throws -> Event {
        let event = Event(id: eventDto.id, title: eventDto.title, eventDescription: eventDto.descriptionText, locationName: eventDto.locationName,
                          roomNumber: eventDto.roomNumber, address: eventDto.address, status: eventDto.status ?? "No status", experience: eventDto.experience ?? "No experience value",
                          eventUrl: URL(string: eventDto.localistUrl ?? ""),
                          streamUrl: URL(string: eventDto.streamUrl ?? ""),
                          ticketUrl: URL(string: eventDto.ticketUrl ?? ""),
                          venueUrl: URL(string: eventDto.venueUrl ?? ""),
                          calendarUrl: URL(string: eventDto.icsUrl ?? ""),
                          photoData: nil,
                          photoUrl: URL(string: eventDto.photoUrl ?? ""),
                          ticketCost: eventDto.ticketCost,
                          start: start, end: end, allDay: allDay,
                          eventLocation: nil,
                          departmentFilters: [], targetAudienceFilters: [], eventTypeFilters: [],
                          context: persistentContainer.viewContext)

        do {
            try saveViewContext()
            return event
        } catch {
            throw error
        }
    }

    @MainActor
    private func addFilter(to event: Event, filter: EventFilterDto, filterType: FilterType) throws {
        let filter = EventFilter(filter: filter, context: persistentContainer.viewContext)
        switch filterType {
        case .department:
            event.addToDepartmentFilters(filter)
        case .eventType:
            event.addToEventTypeFilters(filter)
        case .targetAudience:
            event.addToTargetAudienceFilters(filter)
        }

        do {
            try saveViewContext()
        } catch {
            throw error
        }
    }

    @MainActor
    private func addLocation(to event: Event, geoDto: GeoDto) throws {
        // "location.event = event" causes error: Thread 1: "Illegal attempt to establish a relationship 'event' between objects in different contexts (source = <UOKiosk.EventLocation: 0x60000217b6b0> (entity: EventLocation; id: 0x6000002d1160
        // Something about working with the objectID is thread safe rather than working with the instance directly. So, I think that has to do with why this works
        let copyEvent = persistentContainer.viewContext.object(with: event.objectID) as? Event
        guard let copyEvent = copyEvent else {
            throw EventServiceError.locationsEventDoesNotExist
        }

        let location = EventLocation(geoDto: geoDto, context: persistentContainer.viewContext)
        location.event = copyEvent

        do {
            try saveViewContext()
        } catch {
            throw error
        }
    }

    @MainActor
    private func deleteEvent(_ event: Event) throws {
        persistentContainer.viewContext.delete(event)

        do {
            try saveViewContext()
        } catch {
            throw error
        }
    }

    @MainActor
    private func saveViewContext() throws {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let nserror = error as NSError
            print("!!! Unresolved error \(nserror), \(nserror.userInfo). Failed to save viewContext, rolling back.")
            persistentContainer.viewContext.rollback()
            throw nserror
        }
    }

    private func eventResultsController() -> NSFetchedResultsController<Event>? {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Event.start, ascending: true)]

        return createResultsController(fetchRequest: fetchRequest)
    }

    private func createResultsController<T>(fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>? where T: NSFetchRequestResult {
        /*
         Generic function for creating results controller for any delegate and fetch request
         */
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        guard let _ = try? resultsController.performFetch() else {
            return nil
        }

        return resultsController
    }
}
