//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation
import CoreData

final class EventsService: EventsRepository {
    /*
     This class will use the below attributes in tandem to get the chached events
     and load new ones from the api
     private let apiService: EventsApiServiceProtocol
     private let storageService: EventsStorageProtocol
     */

    /// Parameters:
    ///     delegate: Used to create the NSFetchedResultsController to be used by the view for displaying events data
    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {

        // Try to get the fetchedResultsController, but if it fails or there are no objects saved return nil
        let fetchedResultsController = eventResultsController(with: delegate)
        guard let fetchedResultsController = fetchedResultsController, let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return nil
        }

        // Delete any that are old (ie. their start date is before the current date)
        for event in fetchedObjects {
            if event.start?.compare(Date()) == ComparisonResult.orderedAscending {
                deleteEvent(event)
            }
        }

        // return the events
        return fetchedResultsController
    }

    func fetchNewEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event]? {
        /*
         TODO: Must change a lot here in fetchEvents. Basically, this function should decide how we will fetch, either just going to get data from
         core data or getting data from core data, then deleting events that started before today, and then calling the api to only download new data
         to the core data persistent store.
         */
        var dto: EventsDto? = nil
        do {
            dto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            let errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to replicate."
        }

        guard let dto = dto else {
            return eventResultsController.fetchedObjects
        }

        // If there are no objects fetched then add all the events fetched from the api
        guard let fetchedObjects = eventResultsController.fetchedObjects, eventResultsController.fetchedObjects?.count ?? 0 > 0 else {
            for middleLayer in dto.eventMiddleLayerDto {
                self.addEvent(eventDto: middleLayer.eventDto)
            }
            return eventResultsController.fetchedObjects
        }

        // If an event loaded in has an id that does not equate to any of the id's on the events already saved, then add the event to the persistent store
        for middleLayer in dto.eventMiddleLayerDto {
            var shouldSave = true
            for object in fetchedObjects {
                if object.id == middleLayer.eventDto.id {
                    shouldSave = false
                }
            }
            if shouldSave {
                self.addEvent(eventDto: middleLayer.eventDto)
            }
        }

        return eventResultsController.fetchedObjects
        // TODO: Event in the eventsDto. Here the completion should take an array of event optional (ie. [Event]?) instead of EventsModel?
    }
    
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
            // TODO: Often get the "Thread 2: EXC_BAD_ACCESS (code=1, address=0xfffffffffffffff8)" error here on first run of the application
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save viewContext, rolling back")
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
    
    init(urlString: String) {
        self.urlString = urlString

        persistentContainer = NSPersistentContainer(name: "EventsModel")

        persistentContainer.loadPersistentStores { storeDescription, error in
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    // MARK: Properties
    private let persistentContainer: NSPersistentContainer
    var urlString: String
}
