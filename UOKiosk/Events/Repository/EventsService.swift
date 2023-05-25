//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation
import CoreData

fileprivate enum EventServiceError: Error, LocalizedError {
    case loadingBlocked
    case fetchedResultsProblem

    var errorDescription: String? {
        switch self {
        case .loadingBlocked:
            return NSLocalizedString("Data is already loading elsewhere in EventsService", comment: "")
        case .fetchedResultsProblem:
            return NSLocalizedString("THere was a problem with fetchedResults", comment: "")
        }
    }
}


final class EventsService: EventsRepository {
    /*
     This class will use the below attributes in tandem to get the chached events
     and load new ones from the api
     private let apiService: EventsApiServiceProtocol
     private let storageService: EventsStorageProtocol
     */

    // MARK: Properties
    private let persistentContainer: NSPersistentContainer
    var urlString: String
    var isLoading = false

    // MARK: Initialization
    init(urlString: String) {
        self.urlString = urlString

        persistentContainer = NSPersistentContainer(name: "EventsModel")

        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                print("!!! Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
                fatalError("Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
            }
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    // MARK: Data Getters

    /*
     Logic of getting data:

     On start-up,
        1. Lock usage of Core Data Store so no Pull-To-Refresh can be attempted
        2. Try and get data that is saved. If it is saved use that data and if not then start a new store
        3. Call for fresh data and only save events that are not already stored
        4. delete any outdated data.
     */
    /// Parameters:
    ///     delegate: Used to create the NSFetchedResultsController to be used by the view for displaying events data
    // TODO: Make this function throw an error rather than return an optional
    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        let fetchedResultsController = eventResultsController(with: delegate)
        guard let fetchedResultsController = fetchedResultsController, let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return nil
        }

        // Delete any events that are before the current date
        for event in fetchedObjects {
            // Delete object if it has no start date
            guard let start = event.start else {
                deleteEvent(event)
                continue
            }

            if start.compare(Date()) == .orderedAscending {
                deleteEvent(event)
            }
        }

        return fetchedResultsController
    }

    func updateEventsResultsController(eventResultsController: NSFetchedResultsController<Event>) async throws {
        // TODO: Bug #1 Step 3
        // TODO: Bug #2 Step 3
        let _ = try? await saveFreshEvents(eventResultsController: eventResultsController)

        // IF there are no objects saved return
        guard let fetchedObjects = eventResultsController.fetchedObjects else {
            return
        }

        // Delete any events that are before the current date
        for event in fetchedObjects {
            // Delete object if it has no start date
            guard let start = event.start else {
                deleteEvent(event)
                continue
            }

            if start.compare(Date()) == ComparisonResult.orderedAscending {
                deleteEvent(event)
            }
        }
    }

    // Gets Event data from the Localist REST API and saves it to core data, unless an Event with the same ID as the one revieved by the Localist API is already saved to the Core Data Persistent Store
    private func saveFreshEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event]? {
        var dto: EventsDto? = nil
        do {
            dto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            let _ = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to replicate."
        }

        guard let dto = dto else {
            return eventResultsController.fetchedObjects
        }

        // If there are no objects fetched from the local Core Data store, then add all the events fetched from the api to the Core Data Persistent Store
        guard let fetchedObjects = eventResultsController.fetchedObjects, eventResultsController.fetchedObjects?.count ?? 0 > 0 else {
            for middleLayer in dto.eventMiddleLayerDto { // TODO: Bug #2 Step 4
                self.addEvent(eventDto: middleLayer.eventDto)
            }
            return eventResultsController.fetchedObjects
        }

        // If an event loaded in has an id that does not equate to any of the id's on the events already saved, then add the event to the persistent store
        for middleLayer in dto.eventMiddleLayerDto {
            // Make sure the object has a start date
            guard middleLayer.eventDto.eventInstances?.count ?? 0 > 0, middleLayer.eventDto.eventInstances?[0].eventInstance.start != "" else {
                continue
            }

            var shouldSave = true
            for object in fetchedObjects {
                if object.id == middleLayer.eventDto.id {
                    shouldSave = false
                }
            }

            if !shouldSave {
                continue
            }

            // Make sure there is date info for the event
            guard middleLayer.eventDto.eventInstances?.count ?? 0 > 0 else {
                continue
            }
            let dateValues = getEventInstanceDateData(dateData: middleLayer.eventDto.eventInstances![0].eventInstance)
            let allDay = dateValues.0
            let _ = dateValues.1
            let end = dateValues.2
            if allDay == true {
                // If the event is all day then we should show it
                self.addEvent(eventDto: middleLayer.eventDto)
            }
            guard let end = end else {
                // If the event is not all day, but we do not know when it ends, then we should add it
                self.addEvent(eventDto: middleLayer.eventDto)
                continue
            }
            if end < Date() {
                // If the event is already over then we should not show the event
                continue
            }
            // If the event is not all day, but the end of the event has not happened then add it
            // TODO: Bug #1 Step 4
            self.addEvent(eventDto: middleLayer.eventDto)
        }

        return eventResultsController.fetchedObjects
        // TODO: Event in the eventsDto. Here the completion should take an array of event optional (ie. [Event]?) instead of EventsModel?
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

        if endStr != nil {
            end = dateFormatter.date(from: endStr!)
        } else {
            end = nil
        }

        let allDay = dateData.allDay
        return (allDay, start, end)
    }

    // MARK: Core Data Functions
    func addEvent(eventDto: EventDto) {
        // TODO: Bug #1 Step 5
        // TODO: Bug #2 Step 5
        let _ = Event(eventData: eventDto, context: persistentContainer.viewContext)

        saveViewContext()
    }

    func deleteEvent(_ event: Event) {
        persistentContainer.viewContext.delete(event)

        saveViewContext()
    }
    
    private func saveViewContext() {
        do {
            // TODO: Often get the "Thread 2: EXC_BAD_ACCESS (code=1, address=0xfffffffffffffff8)" error here on first run of the application
            // FIXME: Sometimes this persistentContainer.viewContext.save() is called fro ma background concurrent thread, like when .task is called. Is that causing the problem becasue it's calling to an object on the main thread?
            try persistentContainer.viewContext.save()
        } catch {
            // TODO: Bug #1 Step 6
            // TODO: Bug #2 Step 6
            let nserror = error as NSError
            print("!!! Unresolved error \(nserror), \(nserror.userInfo). Failed to save viewContext, rolling back.")
            persistentContainer.viewContext.rollback()
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
