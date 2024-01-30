//
//  EventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import CoreData

protocol EventsRepository {
    func getImage(for event: Event) async
    func fetchSavedEvents() throws -> [Event]
    func fetchFreshEvents() async throws -> [Event]
//    func getImage(for event: Event) async
//    func fetchSavedEvents() async throws -> [Event]
//    func fetchFreshEvents() async throws -> [Event]


//    func loadFreshEvents() async throws

//    var persistentContainer: NSPersistentContainer { get set }
//
//    func getImage(event: Event)
//    func fetchEvents() async throws -> NSFetchedResultsController<Event>?
//    func fetchSavedEvents() -> NSFetchedResultsController<Event>?
}
