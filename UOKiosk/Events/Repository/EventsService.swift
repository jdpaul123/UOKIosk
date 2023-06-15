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

    // MARK: - Properties
    var persistentContainer: NSPersistentContainer
    var urlString: String
    var isLoading = false

    // MARK: - Initialization
    init(urlString: String) {
        self.urlString = urlString

        persistentContainer = NSPersistentContainer(name: "EventsModel")

        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                print("!!! Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
                fatalError("Failed to load persistent stores for the Events Model with error: \(error?.localizedDescription ?? "Error does not exist")")
            }
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            // NSMergeByPropertyObjectTrumpMergePolicy means that any object that is trying to add an Event Object with the same id as one already saved then it only updates the data rather than saving a second copy
            self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    // MARK: - Get FetchResults From REST API and/or Persisten Store Controller Methods
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

    // MARK: - Helper Methods For updateEventsResultsController
    // Gets Event data from the Localist REST API and saves it to core data. For each Event recieved from the API, it will be saved unless it has the same ID as one already saved to the Core Data Persistent Store
    private func saveFreshEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event] {
        var dto: EventsDto? = nil
        do {
            dto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            // TODO: Add analytics for this error and an error banner
            let _ = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to replicate."
        }

        // FIXME: For some reson if I put a break point at "guard let dto = dto else {" and then pause there for just a second when LLDB hits the breakpoint, then the data arrives in the correct chronological order
        // If the ApiService fails and the dto variable is still nill then return any objects that may be saved
        guard let dto = dto else {
            // TODO: Instead of returning here, throw an error
            return eventResultsController.fetchedObjects ?? []
        }

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
                self.addEvent(eventDto: eventDto)
            }
            guard let end = end else {
                // If the event is not all day, but we do not know when it ends, then we should save it
                self.addEvent(eventDto: eventDto)
                continue
            }
            if end < Date() {
                // If the event is already over then we should not save it
                continue
            }
            // If the event is not all day, but the end of the event is in the future then save it
            self.addEvent(eventDto: eventDto)
        }

        return eventResultsController.fetchedObjects ?? [] // TODO: Above this return add in a check that fetchedObjects exists and has Events, otherwise Throw an error
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

    // MARK: - Core Data Functions
    func addEvent(eventDto: EventDto) {
        let _ = Event(eventData: eventDto, context: persistentContainer.viewContext)

        saveViewContext()
    }

    func deleteEvent(_ event: Event) {
        persistentContainer.viewContext.delete(event)

        saveViewContext()
    }

    private func saveViewContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
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
