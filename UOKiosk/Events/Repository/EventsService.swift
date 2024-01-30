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

fileprivate enum EventsServiceError: Error {
    case noEvents
    case apiError(String)
    case indexOutOfBounds(String)
    case locationsEventDoesNotExist
}

final class EventsService: EventsRepository {
    enum FilterType {
        case department
        case targetAudience
        case eventType
    }

    var persistentContainer: NSPersistentContainer
    let urlString: String
    let context: NSManagedObjectContext
    let saveToCoreDataQueue = DispatchQueue(label: "Save To Core Data")

    // MARK: Init
    init(urlString: String) {
        self.urlString = urlString

        persistentContainer = NSPersistentContainer(name: "EventsModel")
        context = persistentContainer.viewContext
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                print("!!! Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
                return
            }

            // NSMergeByPropertyObjectTrumpMergePolicy means that any object that is trying to add an Event Object with the same id as one already saved then it only updates the data rather than saving a second copy
            self.context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            self.context.automaticallyMergesChangesFromParent = true
        }
    }

    func getImage(for event: Event) async {
        guard event.photoData == nil,
              let photoURL = event.photoUrl,
              let photoData = try? await ApiService.shared.getImageData(from: photoURL) else {
            return
        }

        // TODO: Get rid of imPhotoData in the model by storing the photo data in the ViewModel
        event.photoData = photoData
        event.imPhotoData = photoData
        try? self.saveViewContext()
    }

    // MARK: Fetch Saved Events
    func fetchSavedEvents() throws -> [Event] {
        let fetchedResultsController = try eventResultsController()
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            throw EventsServiceError.noEvents
        }

        // Delete any events that occured before the current date
        let cal = Calendar(identifier: .gregorian)
        let nowDay = cal.component(.day, from: .now)
        let nowMonth = cal.component(.month, from: .now)
        let nowYear = cal.component(.year, from: .now)
        let today = cal.date(from: DateComponents(year: nowYear, month: nowMonth, day: nowDay))
        if let today {
            for event in fetchedObjects {
                // Delete any events from before today, but don't throw if it fails
                if event.start.compare(today) == .orderedAscending {
                    do {
                        try context.performAndWait {
                            try deleteEvent(event)
                        }
                    } catch {
                        let nsError = error as NSError
                        print("!!! Error deleting event: \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }

        // TODO: Does fetchedObjects now return the updated array without the deleted events?
        return fetchedObjects
    }

    // MARK: Delete Core Data Models
    private func deleteEvent(_ event: Event) throws {
        context.delete(event)
        try saveViewContext()
    }

    // MARK: Load Fresh Events
    func fetchFreshEvents() async throws -> [Event] {
        try await loadFreshEvents()
        return try fetchSavedEvents()
    }


    func loadFreshEvents() async throws {
        let dto: EventsDto = try await ApiService.shared.getJSON(urlString: urlString)
        let eventDtos = cleanDtoData(for: dto)
        try saveEventsWithFiltersAndLocations(from: eventDtos)
    }

    private func getEventInstanceDateData(dateData: EventInstanceDto) -> (allDay: Bool, start: Date, end: Date?) {
        let startStr: String = dateData.start
        let endStr: String? = dateData.end

        // Format the start and end dates if they exist
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"

        let start = {
            guard let date = dateFormatter.date(from: startStr) else {
                fatalError("Start date could not be determined form the provided date string")
            }
            return date
        }()

        let end: Date?
        if let endStr {
            end = dateFormatter.date(from: endStr)
        } else {
            end = nil
        }

        let allDay = dateData.allDay

        return (allDay, start, end)
    }

    private func cleanDtoData(for dto: EventsDto) -> [EventDto] {
        var eventDtos = [EventDto]()
        // Get rid of events with no date info or are already over
        for middleLayer in dto.eventMiddleLayerDto {
            let eventDto = middleLayer.eventDto
            // Make sure there is date info for the event and that the object has a start date
            guard let eventInstanceWrapper = eventDto.eventInstances?[0],
                    eventInstanceWrapper.eventInstance.start != "" else {
                continue
            }

            let dateValues = getEventInstanceDateData(dateData: eventInstanceWrapper.eventInstance)
            // If the event is already over then we should not save it
            if let end = dateValues.end, end < Date() {
                continue
            }

            eventDtos.append(eventDto)
        }
        return eventDtos
    }

    private func saveEventsWithFiltersAndLocations(from eventDtos: [EventDto]) throws {
        for eventDto in eventDtos {
            guard let eventInstances = eventDto.eventInstances else {
                throw EventsServiceError.apiError("Event instances could not be found for event: \(eventDto.title)")
            }

            guard let eventInstance = eventInstances.first else {
                throw EventsServiceError.indexOutOfBounds("Event instances could not be found for event: \(eventDto.title)")
            }
            let dateData = eventInstance.eventInstance
            let dateValues = getEventInstanceDateData(dateData: dateData)

            // Add the event
            try context.performAndWait {
                let event = try addEvent(eventDto, start: dateValues.start, end: dateValues.end, allDay: dateValues.allDay)

                // Add the relationships to the event
                if let eventTypeFilters = eventDto.filters.eventTypes {
                    for eventTypeFilter in eventTypeFilters {
                        try addFilter(to: event, filter: eventTypeFilter, filterType: .eventType)
                    }
                }
                if let departmentFilters = eventDto.filters.departments {
                    for departmentFilter in departmentFilters {
                        try addFilter(to: event, filter: departmentFilter, filterType: .department)
                    }
                }
                if let targetAudienceFilters = eventDto.filters.eventTargetAudience {
                    for targetAudienceFilter in targetAudienceFilters {
                        try addFilter(to: event, filter: targetAudienceFilter, filterType: .targetAudience)
                    }
                }

                if let geoDto = eventDto.geo {
                    try addLocation(to: event, geoDto: geoDto)
                }
            }
        }
    }

    // MARK: Create Core Data Models
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
                          context: context)

        try saveViewContext()
        return event
    }

    private func addFilter(to event: Event, filter: EventFilterDto, filterType: FilterType) throws {
        let copyEvent = try getCopy(of: event)

        let filter = EventFilter(filter: filter, context: context)
        switch filterType {
        case .department:
            filter.addToDepartmentEvents(copyEvent)
        case .eventType:
            filter.addToEventTypeEvents(copyEvent)
        case .targetAudience:
            filter.addToTargetAudienceEvents(copyEvent)
        }

        try saveViewContext()
    }

    private func addLocation(to event: Event, geoDto: GeoDto) throws {
        let copyEvent = try getCopy(of: event)

        let location = EventLocation(geoDto: geoDto, context: context)
        location.event = copyEvent

        try saveViewContext()
    }

    // Getting the event by it's objectID is the thread safe way of doing this
    private func getCopy(of event: Event) throws -> Event {
        let copyEvent = context.object(with: event.objectID) as? Event
        guard let copyEvent = copyEvent else {
            throw EventsServiceError.locationsEventDoesNotExist
        }

        return copyEvent
    }


    // MARK: Core Data functions
    private func saveViewContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            print("!!! Unresolved error \(nserror.localizedDescription), \(nserror.userInfo). Failed to save viewContext, rolling back.")
            context.rollback()
            throw nserror
        }
    }

    private func eventResultsController() throws -> NSFetchedResultsController<Event> {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Event.start, ascending: true)]

        return try createResultsController(fetchRequest: fetchRequest)
    }

    /// Generic function for creating results controller for any delegate and fetch request
    private func createResultsController<T>(fetchRequest: NSFetchRequest<T>) throws -> NSFetchedResultsController<T> where T: NSFetchRequestResult {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try resultsController.performFetch()

        return resultsController
    }
}

//class EventsService: EventsRepository {
//    enum FilterType {
//        case department
//        case targetAudience
//        case eventType
//    }
//
//    enum EventServiceError: Error {
//        case locationsEventDoesNotExist
//
//        var errorDescription: String? {
//            switch self {
//            case .locationsEventDoesNotExist:
//                return NSLocalizedString("While adding a Location object to the Core Data store there was no Event found to create a relation to from the Location", comment: "")
//            }
//        }
//    }
//
//    // MARK: Properties
//    private let urlString: String
//    var persistentContainer: NSPersistentContainer
//    private var lastDataUpdateDate: Date {
//        didSet {
//            // Save the day date that the data is updated to compare with the date on subsiquent application boot ups.
//            UserDefaults.standard.set(lastDataUpdateDate, forKey: "lastDataUpdateDate")
//        }
//    }
//    private var isLastUpdatedToday: Bool
//    private var cancellables = Set<AnyCancellable>()
//    @Published var events: [Event] = [Event]()
//
//    // MARK: Init
//    init(urlString: String) {
//        self.urlString = urlString
//        self.lastDataUpdateDate = UserDefaults.standard.object(forKey: "lastDataUpdateDate") as? Date ?? Date(timeIntervalSince1970: 0)
//        self.isLastUpdatedToday = Calendar(identifier: .gregorian).isDateInToday(lastDataUpdateDate)
//
//        persistentContainer = NSPersistentContainer(name: "EventsModel")
//        persistentContainer.loadPersistentStores { storeDescription, error in
//            guard error == nil else {
//                print("!!! Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
//                return
//            }
//
//            // TODO: What is NSPersistentHistoryTrackingKey for? Am I actually using it
////            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
//
//            // NSMergeByPropertyObjectTrumpMergePolicy means that any object that is trying to add an Event Object with the same id as one already saved then it only updates the data rather than saving a second copy
//            self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
//        }
//    }
//
//    // TODO: Make it so getImage(event:) is only called when fetchFreshEvents() is too so that the method is not called every time the app is run
//    func getImage(event: Event) {
//        guard let photoUrl = event.photoUrl else {
//            return
//        }
//        URLSession.shared.dataTaskPublisher(for: photoUrl)
//            .sink { completion in
//                // TODO: Add error handling
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("!!! Failed to get photo for event, \(event.title), with error: \(error.localizedDescription)")
//                }
//            } receiveValue: { [weak self] (data, respose) in
//                guard let self else { return }
//                event.photoData = data
//                event.imPhotoData = data
//                Task {
//                    try? await self.saveViewContext()
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    // MARK: Get events (determine if getting saved events or fetching events from REST API then getting saved events)
//    func fetchEvents() async throws -> NSFetchedResultsController<Event>? {
//        if !isLastUpdatedToday {
//            lastDataUpdateDate = .now
//            // call api for fresh data
//            try await fetchFreshEvents()
//        }
//
//        let resultsController = fetchSavedEvents()
//        guard let resultsController = resultsController, let fetchedObjects = resultsController.fetchedObjects,
//              !fetchedObjects.isEmpty else {
//            // call api for fresh data
//            try await fetchFreshEvents()
//            return fetchSavedEvents()
//        }
//        return resultsController
//    }
//
//    // MARK: Get Saved Events
//    func fetchSavedEvents() async -> NSFetchedResultsController<Event>? {
//        let fetchedResultsController = eventResultsController()
//        guard let fetchedResultsController = fetchedResultsController, let fetchedObjects = fetchedResultsController.fetchedObjects else {
//            return nil
//        }
//
//        let cal = Calendar(identifier: .gregorian)
//        let nowDay = cal.component(.day, from: .now)
//        let nowMonth = cal.component(.month, from: .now)
//        let nowYear = cal.component(.year, from: .now)
//        let today = cal.date(from: DateComponents(year: nowYear, month: nowMonth, day: nowDay))
//        guard let today = today else {
//            return fetchedResultsController
//        }
//
//        // Delete any events that are before the current date
//        for event in fetchedObjects {
//            // Delete any events from before today
//            if event.start.compare(today) == .orderedAscending {
//                try? await deleteEvent(event)
//            }
//        }
//        return fetchedResultsController
//    }
//
//
//
//    // MARK: Get Fresh Events
//    private func fetchFreshEvents() async throws {
//        let dto: EventsDto = try await ApiService.shared.getJSON(urlString: urlString)
//
//        var eventDtos = [EventDto]()
//        // If an event loaded in has an id that does not equate to any of the id's on the events already saved, then add the event to the persistent store
//        for middleLayer in dto.eventMiddleLayerDto {
//            let eventDto = middleLayer.eventDto
//            // Make sure there is date info for the event and that the object has a start date
//            guard let eventInstanceWrapper = eventDto.eventInstances?[0], eventInstanceWrapper.eventInstance.start != "" else {
//                continue
//            }
//
//            let dateValues = getEventInstanceDateData(dateData: eventInstanceWrapper.eventInstance)
//            let allDay = dateValues.allDay
//            let _ = dateValues.start
//            let end = dateValues.end
//            if allDay == true {
//                // If the event is all day then we should save it
//                eventDtos.append(eventDto)
//            }
//            guard let end = end else {
//                // If the event is not all day, but we do not know when it ends, then we should save it
//                eventDtos.append(eventDto)
//                continue
//            }
//            if end < Date() {
//                // If the event is already over then we should not save it
//                continue
//            }
//            // If the event is not all day, but the end of the event is in the future then save it
//            eventDtos.append(eventDto)
//        }
//
//        for eventDto in eventDtos {
//            guard let eventInstances = eventDto.eventInstances else {
//                fatalError("There are no event instances to access")
//            }
//            let dateData = eventInstances[0].eventInstance
//            let dateValues = getEventInstanceDateData(dateData: dateData)
//
//            // Add the event
//            let event = try await addEvent(eventDto, start: dateValues.start, end: dateValues.end, allDay: dateValues.allDay)
//
//            // Add the relationships to the event
//            if let eventTypeFilters = eventDto.filters.eventTypes {
//                for eventTypeFilter in eventTypeFilters {
//                    try await addFilter(to: event, filter: eventTypeFilter, filterType: .eventType)
//                }
//            }
//            if let departmentFilters = eventDto.filters.departments {
//                for departmentFilter in departmentFilters {
//                    try await addFilter(to: event, filter: departmentFilter, filterType: .department)
//                }
//            }
//            if let targetAudienceFilters = eventDto.filters.eventTargetAudience {
//                for targetAudienceFilter in targetAudienceFilters {
//                    try await addFilter(to: event, filter: targetAudienceFilter, filterType: .targetAudience)
//                }
//            }
//
//            if let geoDto = eventDto.geo {
//                try await addLocation(to: event, geoDto: geoDto)
//            }
//        }
//    }
//
//    private func getEventInstanceDateData(dateData: EventInstanceDto) -> (allDay: Bool, start: Date, end: Date?) {
//        let startStr: String = dateData.start
//        let endStr: String? = dateData.end
//
//        // Format the start and end dates if they exist
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
//        let start: Date
//        let end: Date?
//
//        start = {
//            guard let date = dateFormatter.date(from: startStr) else {
//                fatalError("Start date could not be determined form the provided date string")
//            }
//            return date
//        }()
//
//        if let endStr = endStr {
//            end = dateFormatter.date(from: endStr)
//        } else {
//            end = nil
//        }
//
//        let allDay = dateData.allDay
//        return (allDay, start, end)
//    }
//
//    private func addEvent(_ eventDto: EventDto, start: Date, end: Date?, allDay: Bool) async throws -> Event {
//        let event = Event(id: eventDto.id, title: eventDto.title, eventDescription: eventDto.descriptionText, locationName: eventDto.locationName,
//                          roomNumber: eventDto.roomNumber, address: eventDto.address, status: eventDto.status ?? "No status", experience: eventDto.experience ?? "No experience value",
//                          eventUrl: URL(string: eventDto.localistUrl ?? ""),
//                          streamUrl: URL(string: eventDto.streamUrl ?? ""),
//                          ticketUrl: URL(string: eventDto.ticketUrl ?? ""),
//                          venueUrl: URL(string: eventDto.venueUrl ?? ""),
//                          calendarUrl: URL(string: eventDto.icsUrl ?? ""),
//                          photoData: nil,
//                          photoUrl: URL(string: eventDto.photoUrl ?? ""),
//                          ticketCost: eventDto.ticketCost,
//                          start: start, end: end, allDay: allDay,
//                          eventLocation: nil,
//                          departmentFilters: [], targetAudienceFilters: [], eventTypeFilters: [],
//                          context: persistentContainer.viewContext)
//
//
//        try await saveViewContext()
//        return event
//    }
//
//    private func addFilter(to event: Event, filter: EventFilterDto, filterType: FilterType) async throws {
//        let filter = EventFilter(filter: filter, context: persistentContainer.viewContext)
//        try await saveViewContext()
//        persistentContainer.viewContext.performAndWait {
//            switch filterType {
//            case .department:
//                event.addToDepartmentFilters(filter)
//            case .eventType:
//                event.addToEventTypeFilters(filter)
//            case .targetAudience:
//                event.addToTargetAudienceFilters(filter)
//            }
//        }
//        try await saveViewContext()
//    }
//
//    private func addLocation(to event: Event, geoDto: GeoDto) async throws {
//        // "location.event = event" causes error: Thread 1: "Illegal attempt to establish a relationship 'event' between objects in different contexts (source = <UOKiosk.EventLocation: 0x60000217b6b0> (entity: EventLocation; id: 0x6000002d1160
//        // Something about working with the objectID is thread safe rather than working with the instance directly. So, I think that has to do with why this works
//        let copyEvent = persistentContainer.viewContext.object(with: event.objectID) as? Event
//        guard let copyEvent = copyEvent else {
//            throw EventServiceError.locationsEventDoesNotExist
//        }
//
//        let location = EventLocation(geoDto: geoDto, context: persistentContainer.viewContext)
//        location.event = copyEvent
//
//        try await saveViewContext()
//    }
//
//    private func deleteEvent(_ event: Event) async throws {
//        persistentContainer.viewContext.delete(event)
//
//        try await saveViewContext()
//    }
//
//    private func saveViewContext() async throws {
//        if !persistentContainer.viewContext.hasChanges { return }
//        try await persistentContainer.viewContext.perform { [weak self] in
//            guard let self else { return }
//            do {
//                try persistentContainer.viewContext.save()
//            } catch {
//                let nserror = error as NSError
//                print("!!! Unresolved error \(nserror), \(nserror.userInfo). Failed to save viewContext, rolling back.")
//                persistentContainer.viewContext.rollback()
//                throw nserror
//            }
//        }
////        try persistentContainer.viewContext.performAndWait {
////            do {
////                try persistentContainer.viewContext.save()
////            } catch {
////                let nserror = error as NSError
////                print("!!! Unresolved error \(nserror), \(nserror.userInfo). Failed to save viewContext, rolling back.")
////                persistentContainer.viewContext.rollback()
////                throw nserror
////            }
////        }
//    }
//
//    private func eventResultsController() -> NSFetchedResultsController<Event>? {
//        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Event.start, ascending: true)]
//
//        return createResultsController(fetchRequest: fetchRequest)
//    }
//
//    private func createResultsController<T>(fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>? where T: NSFetchRequestResult {
//        /*
//         Generic function for creating results controller for any delegate and fetch request
//         */
//        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//
//        guard let _ = try? resultsController.performFetch() else {
//            return nil
//        }
//
//        return resultsController
//    }
//}
