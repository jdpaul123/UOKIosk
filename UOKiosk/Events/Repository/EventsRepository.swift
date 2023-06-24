//
//  EventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation
import CoreData

protocol EventsRepository {
    func fetchEvents(with delegate: NSFetchedResultsControllerDelegate) async throws -> NSFetchedResultsController<Event>?
    func fetchFreshEvents() async throws /*-> [IMEvent]*/
    func fetchSavedEvents(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Event>?

    func getFreshEvents() async throws -> [IMEvent]
}
