//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation

class EventsService: EventsRepository {
    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }
}
