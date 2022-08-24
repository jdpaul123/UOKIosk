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
    
    /// Parameters:
    ///     eventResultsController: The eventResultsController that should be updated to show the new events
    /// This function expects that the eventResultsController has already been created through a call to the fetchSavedEvents method on the EventsService class
    func fetchNewEvents(eventResultsController: NSFetchedResultsController<Event>) {
        /*
         TODO: Must change a lot here in fetchEvents. Basically, this function should decide how we will fetch, either just going to get data from
         core data or getting data from core data, then deleting events that started before today, and then calling the api to only download new data
         to the core data persistent store.
         */
        ApiService.shared.loadApiData(urlString: urlString, completion: { [self] (dto: EventsDto?) in
            guard let dto = dto else {
                print("failed to decode the apiService's data from the API")
                return
            }
            
            // If there are no objects fetched then add all the events fetched from the api
            guard let fetchedObjects = eventResultsController.fetchedObjects, eventResultsController.fetchedObjects?.count ?? 0 > 0 else {
                for middleLayer in dto.eventMiddleLayerDto {
                    self.addEvent(eventDto: middleLayer.eventDto)
                }
                return
            }
            
            // If an event loaded in has an id that does not equate to any of the id's on the events already saved, then add the event to the persistent store
            for middleLayer in dto.eventMiddleLayerDto {
                let event = Event(eventData: middleLayer.eventDto, context: self.persistentContainer.viewContext)
                if !fetchedObjects.contains(event) {
                    self.addEvent(eventDto: middleLayer.eventDto)
                }
            }
            // TODO: Event in the eventsDto. Here the completion should take an array of event optional (ie. [Event]?) instead of EventsModel?
        })
    }
    
    func fetchEvents(completion: @escaping (EventsModel?) -> Void) {
        ApiService.shared.loadApiData(urlString: urlString, completion: { (dto: EventsDto?) in
            var eventsModel: EventsModel? = nil
            guard let dto = dto else {
                print("failed to decode the apiService's html GET from the API")
                return
            }
            eventsModel = EventsModel(eventsData: dto)
            completion(eventsModel)
        })
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
            
            // TODO: Use the below 5 lines to do anything if there is no data loaded in, otherwise delete the code.
            let context = self.persistentContainer.newBackgroundContext()
            context.perform {
                let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
                let count = try! context.count(for: fetchRequest)
                // if the count is 0 then we should load data in from the api
                // if the count is not 0 then we should check the lastUpdateDate, and if that is today then we should do nothing
                // otherwise we should load in the data saved, delete whatever is older than today, and then load in any new data from the api
            }
        }
    }
    
    // MARK: Properties
    private let persistentContainer: NSPersistentContainer
    var urlString: String
}
