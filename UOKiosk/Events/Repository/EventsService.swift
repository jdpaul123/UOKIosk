//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import CoreData

/*
 TODO: Call service to get events.
 The service will decide if it just gets data from the Core Data Persistent Store
 or if it calls the api for fresh data, waits for it, and returns data from the Persistent Store.

 Once that works, impliment pull-to-refrehs which will perform the fetchEvents that is described above but it will call
 the api every time.

 Note: Get the events from API and turn into IMEvent (Event should have all of the same properties as IMEvent) then save the
 IMEvents to Core Data Event entities. Then the view can display the fetched results.
 */

class EventsService: EventsRepository {
    // MARK: Properties
    let urlString: String
    var persistentContainer: NSPersistentContainer
    private var lastDataUpdateDate: Date {
        didSet {
            // Save the day date that the data is updated to compare with the date on subsiquent application boot ups.
            UserDefaults.standard.set(lastDataUpdateDate, forKey: "lastDataUpdateDate")
        }
    }
    private var isLastUpdatedToday: Bool

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
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            // NSMergeByPropertyObjectTrumpMergePolicy means that any object that is trying to add an Event Object with the same id as one already saved then it only updates the data rather than saving a second copy
            self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    // MARK: OLD GET EVENTS FROM API FUNCTION
    func getFreshEvents() async throws -> [IMEvent] {
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
            let allDay = dateValues.0
            let _ = dateValues.1
            let end = dateValues.2
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

        var events = [IMEvent]()
        for eventDto in eventDtos {
            guard let eventInstances = eventDto.eventInstances else {
                fatalError("There are no event instances to access")
            }
            let dateData = eventInstances[0].eventInstance
            let dateValues = getEventInstanceDateData(dateData: dateData)

            var eventTypeFilters = [IMEventFilter]()
            var departmentFilters = [IMEventFilter]()
            var targetAudienceFilters = [IMEventFilter]()

            let event = IMEvent(id: eventDto.id, title: eventDto.title, eventDescription: eventDto.descriptionText, locationName: eventDto.locationName,
                                roomNumber: eventDto.roomNumber, address: eventDto.address, status: eventDto.status, experience: eventDto.experience,
                                eventUrl: URL(string: eventDto.localistUrl ?? ""),
                                streamUrl: URL(string: eventDto.streamUrl ?? ""),
                                ticketUrl: URL(string: eventDto.ticketUrl ?? ""),
                                venueUrl: URL(string: eventDto.venueUrl ?? ""),
                                calendarUrl: URL(string: eventDto.icsUrl ?? ""),
                                photoUrl: URL(string: eventDto.photoUrl ?? ""),
                                photoData: nil, // photo data is loaded asyncronously after instantiation
                                ticketCost: eventDto.ticketCost,
                                start: dateValues.1, end: dateValues.2, allDay: dateValues.0,
                                departmentFilters: departmentFilters, targetAudienceFilters: targetAudienceFilters, eventTypeFilters: eventTypeFilters)

            // Create the relationships
            if let dtoEventFilters = eventDto.filters.eventTypes {
                for eventFilter in dtoEventFilters {
                    eventTypeFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name, event: event))
                }
            }
            if let dtoDepartmentFilters = eventDto.filters.departments {
                for eventFilter in dtoDepartmentFilters {
                    departmentFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name, event: event))
                }
            }
            if let dtoTargetAudienceFilters = eventDto.filters.eventTargetAudience {
                for eventFilter in dtoTargetAudienceFilters {
                    targetAudienceFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name, event: event))
                }
            }
            event.eventTypeFilters = eventTypeFilters
            event.departmentFilters = departmentFilters
            event.targetAudienceFilters = targetAudienceFilters

            let eventLocation = IMEventLocation(latitude: Double(eventDto.geo?.latitude ?? "0.0") ?? 0.0, longitude: Double(eventDto.geo?.longitude ?? "0.0") ?? 0.0, street: eventDto.geo?.street, city: eventDto.geo?.city, country: eventDto.geo?.country, zip: Int64(Int(eventDto.geo?.zip ?? "0") ?? 0), event: event)
            event.eventLocation = eventLocation

            events.append(event)
        }

        // TODO: The saveEvents method call below is for testing
        await saveEvents(imEvents: events)

        return events
    }

    // MARK: Get events (determine if getting saved events or fetching events from REST API then getting saved events)
    @MainActor
    func fetchEvents(with delegate: NSFetchedResultsControllerDelegate) async throws -> NSFetchedResultsController<Event>? {
        if !isLastUpdatedToday {
            lastDataUpdateDate = .now
            // call api for fresh data
            do {
                try await fetchFreshEvents()
            } catch {
                throw error
            }
        }
        // return saved data
        return fetchSavedEvents(with: delegate)
    }

    // MARK: Get Saved Events
    @MainActor
    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        let fetchedResultsController = eventResultsController(with: delegate)
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
            // Delete any events that start before the instantiation of this view
//            if start.compare(Date()) == .orderedAscending {
//                try? deleteEvent(event)
//            }
        }
        return fetchedResultsController
    }

    // MARK: Get Fresh Events
    func fetchFreshEvents() async throws /*-> [IMEvent]*/ {
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
            let allDay = dateValues.0
            let _ = dateValues.1
            let end = dateValues.2
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

        var events = [IMEvent]()
        for eventDto in eventDtos {
            guard let eventInstances = eventDto.eventInstances else {
                fatalError("There are no event instances to access")
            }
            let dateData = eventInstances[0].eventInstance
            let dateValues = getEventInstanceDateData(dateData: dateData)

            var eventTypeFilters = [IMEventFilter]()
            var departmentFilters = [IMEventFilter]()
            var targetAudienceFilters = [IMEventFilter]()

            let event = IMEvent(id: eventDto.id, title: eventDto.title, eventDescription: eventDto.descriptionText, locationName: eventDto.locationName,
                                roomNumber: eventDto.roomNumber, address: eventDto.address, status: eventDto.status, experience: eventDto.experience,
                                eventUrl: URL(string: eventDto.localistUrl ?? ""),
                                streamUrl: URL(string: eventDto.streamUrl ?? ""),
                                ticketUrl: URL(string: eventDto.ticketUrl ?? ""),
                                venueUrl: URL(string: eventDto.venueUrl ?? ""),
                                calendarUrl: URL(string: eventDto.icsUrl ?? ""),
                                photoUrl: URL(string: eventDto.photoUrl ?? ""),
                                photoData: nil, // photo data is loaded asyncronously after instantiation
                                ticketCost: eventDto.ticketCost,
                                start: dateValues.1, end: dateValues.2, allDay: dateValues.0,
                                departmentFilters: departmentFilters, targetAudienceFilters: targetAudienceFilters, eventTypeFilters: eventTypeFilters)

            // Create the relationships
            if let dtoEventFilters = eventDto.filters.eventTypes {
                for eventFilter in dtoEventFilters {
                    eventTypeFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name, event: event))
                }
            }
            if let dtoDepartmentFilters = eventDto.filters.departments {
                for eventFilter in dtoDepartmentFilters {
                    departmentFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name, event: event))
                }
            }
            if let dtoTargetAudienceFilters = eventDto.filters.eventTargetAudience {
                for eventFilter in dtoTargetAudienceFilters {
                    targetAudienceFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name, event: event))
                }
            }
            event.eventTypeFilters = eventTypeFilters
            event.departmentFilters = departmentFilters
            event.targetAudienceFilters = targetAudienceFilters

            let eventLocation = IMEventLocation(latitude: Double(eventDto.geo?.latitude ?? "0.0") ?? 0.0, longitude: Double(eventDto.geo?.longitude ?? "0.0") ?? 0.0, street: eventDto.geo?.street, city: eventDto.geo?.city, country: eventDto.geo?.country, zip: Int64(Int(eventDto.geo?.zip ?? "0") ?? 0), event: event)
            event.eventLocation = eventLocation

            events.append(event)
        }

        await saveEvents(imEvents: events)
        //return events // TODO: Above this return, once Core Data is implimented add in a check that fetchedObjects exists and has Events, otherwise Throw an error
    }

    private func getEventInstanceDateData(dateData: EventInstanceDto) -> (Bool, Date, Date?) {
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

    // MARK: - Turn In-Memory (IM) objects into Core Data entities
    @MainActor
    func saveEvents(imEvents: [IMEvent]) {
        for imEvent in imEvents {
            let event = try? addEvent(imEvent: imEvent)
            if let eventLocation = imEvent.eventLocation, let event = event {
                let _ = try? addLocation(location: eventLocation, event: event)
                addEventFilters(imEvent: imEvent, event: event)
            }
        }
    }

    // MARK: - Core Data Functions
    @MainActor
    func addEventFilters(imEvent: IMEvent, event: Event) {
        for imFilter in imEvent.eventTypeFilters {
            let filter = try? addFilter(imFilter: imFilter)
            if let filter = filter {
                event.addToEventTypeFilters(filter)
            }
        }
        for imFilter in imEvent.departmentFilters {
            let filter = try? addFilter(imFilter: imFilter)
            if let filter = filter {
                event.addToDepartmentFilters(filter)
            }
        }
        for imFilter in imEvent.targetAudienceFilters {
            let filter = try? addFilter(imFilter: imFilter)
            if let filter = filter {
                event.addToTargetAudienceFilters(filter)
            }
        }
    }

    @MainActor
    func addFilter(imFilter: IMEventFilter) throws -> EventFilter {
        let filter = EventFilter(id: imFilter.id, name: imFilter.name, context: persistentContainer.viewContext)

        do {
            try saveViewContext()
            return filter
        } catch {
            throw error
        }
    }

    @MainActor
    func addLocation(location: IMEventLocation, event: Event) throws {
        let location = EventLocation(location: location, context: persistentContainer.viewContext)
        event.eventLocation = location

        do {
            try saveViewContext()
        } catch {
            throw error
        }
    }

    @MainActor
    func addEvent(eventDto: EventDto) throws {
        let _ = Event(eventData: eventDto, context: persistentContainer.viewContext)

        do {
            try saveViewContext()
        } catch {
            throw error
        }
    }

    @MainActor
    func addEvent(imEvent: IMEvent) throws -> Event {
        let event = Event(eventData: imEvent, context: persistentContainer.viewContext)

        do {
            try saveViewContext()
            return event
        } catch {
            throw error
        }
    }

    @MainActor
    func deleteEvent(_ event: Event) throws {
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

    func eventResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Event.start, ascending: true)]

        return createResultsController(for: delegate, fetchRequest: fetchRequest)
    }

    private func createResultsController<T>(for delegate: NSFetchedResultsControllerDelegate, fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>? where T: NSFetchRequestResult {
        /*
         Generic function for creating results controller for any delegate and fetch request
         */
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = delegate

        guard let _ = try? resultsController.performFetch() else {
            return nil
        }

        return resultsController
    }
}
