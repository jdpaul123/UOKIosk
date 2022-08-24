//
//  EventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation
import CoreData

protocol EventsRepository {
    /*
     This function will be used to get the event Models
     
     In the case of the App:
     - It will get the Data from the API or core data
     In the case of testing:
     - It will be used to make a mock repository for testing on local data not relying on a network connection
     */
    
    func fetchEvents(completion: @escaping (EventsModel?) -> Void)
    
    func eventResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>?
    
    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>?
        
    func fetchNewEvents(eventResultsController: NSFetchedResultsController<Event>, completion: @escaping ([Event]?) -> Void)
}
