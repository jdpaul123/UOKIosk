//
//  MockEventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation
import CoreData


final class MockEventsService: EventsRepository {
    func eventResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        return nil
    }

    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>? {
        return nil
    }

    func fetchNewEvents(eventResultsController: NSFetchedResultsController<Event>) async throws -> [Event]? {
        await MockEventsModelData().events
    }
}
