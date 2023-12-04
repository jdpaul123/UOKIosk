//
//  MockEventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation
import CoreData
@testable import UOKiosk


final class MockEventsService: EventsRepository {
    func getImage(event: Event) {
        return
    }

//    func fetchEvents(with delegate: NSFetchedResultsControllerDelegate) async throws -> NSFetchedResultsController<Event>? {
//        return nil
//    }
    func fetchEvents() async throws -> NSFetchedResultsController<Event>? {
        return nil
    }

    func fetchFreshEvents() async throws {
        return
    }

//    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
//        return nil
//    }
    func fetchSavedEvents() -> NSFetchedResultsController<Event>? {
        return nil
    }
//    var persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "Mock")
//
//
//    func updateEventsResultsController(eventResultsController: NSFetchedResultsController<Event>) async throws {
//    }
//
//    func eventResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
//        return nil
//    }
//
//    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
//        return nil
//    }
//
//    func saveFreshEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event]? {
//        /* TODO
//         2 ways to do this:
//            1. Hard code a bunch of events and return them
//            2. Decode the JSON that is in MockEventsData.json and return the objects as [Event] type
//         */
//        MockEventsModelData().events
//    }
}
