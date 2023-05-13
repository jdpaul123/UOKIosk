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

        // Delete any events that are before the current date
        for event in fetchedObjects {
            // TODO: Bug: Because we are using GMT for time when we save events we need to adjust their time data to be in pacific time
            if event.start?.compare(Date()) == ComparisonResult.orderedAscending {
                deleteEvent(event)
            }
        }

        // return the events
        return fetchedResultsController
    }

    func fetchNewEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event]? {
        func getEventInstanceDateData(dateData: EventInstanceDto) -> (Bool, Date, Date?) {
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

        var dto: EventsDto? = nil
        do {
            dto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            let errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to replicate."
        }

        guard let dto = dto else {
            return eventResultsController.fetchedObjects
        }

        // If there are no objects fetched from the local Core Data store, then add all the events fetched from the api to the Core Data Persistent Store
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

            if !shouldSave {
                continue
            }

            // Make sure there is date info for the event
            guard middleLayer.eventDto.eventInstances?.count ?? 0 > 0 else {
                continue
            }
            let dateValues = getEventInstanceDateData(dateData: middleLayer.eventDto.eventInstances![0].eventInstance)
            let allDay = dateValues.0
            let start = dateValues.1
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
            self.addEvent(eventDto: middleLayer.eventDto)
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
//            print("Failed to save viewContext, rolling back")
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
