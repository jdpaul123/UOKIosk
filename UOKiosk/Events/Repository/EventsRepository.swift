//
//  EventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import CoreData

protocol EventsRepository {
    var persistentContainer: NSPersistentContainer { get set }

    func getImage(event: Event)
    func fetchEvents() async throws -> NSFetchedResultsController<Event>?
//    func fetchFreshEvents() async throws /*-> [IMEvent]*/
    func fetchSavedEvents() -> NSFetchedResultsController<Event>?
}
