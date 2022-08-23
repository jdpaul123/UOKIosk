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
    
    func addEvent() {}
    
    func deleteEvent() {}
    
    private func saveViewContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save viewContext, rolling back")
            persistentContainer.viewContext.rollback()
        }
    }
    
    func eventsResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Events>? {
        /*
         TODO: Should I delete this fetch request becasue when requesting Event it will give me all the events sorted, rather than events which will give me the single Events instance I have?
         */
        let fetchRequest: NSFetchRequest<Events> = Events.fetchRequest()
        
        return createResultsController(for: delegate, fetchRequest: fetchRequest)
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
                let fetchRequest: NSFetchRequest<Events> = Events.fetchRequest()
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
