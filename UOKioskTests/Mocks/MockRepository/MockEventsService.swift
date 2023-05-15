//
//  MockEventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation
import CoreData


final class MockEventsService: EventsRepository {

    func updateEventsResultsController(eventResultsController: NSFetchedResultsController<Event>) async throws {
    }

    func eventResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        return nil
    }

    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        return nil
    }

    func saveFreshEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event]? {
        /* TODO
         2 ways to do this:
            1. Hard code a bunch of events and return them
            2. Decode the JSON that is in MockEventsData.json and return the objects as [Event] type
         */
        await MockEventsModelData().events
    }
}
