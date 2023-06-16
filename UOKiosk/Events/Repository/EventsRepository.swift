//
//  EventsRepository.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation

protocol EventsRepository {
    func getFreshEvents() async throws -> [IMEvent]
}
