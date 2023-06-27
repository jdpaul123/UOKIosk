//
//  IMEventFilter.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation

class IMEventFilter: Identifiable {
    let id: Int
    let name: String
    weak var event: IMEvent?

    init(id: Int, name: String, event: IMEvent) {
        self.id = id
        self.name = name
        self.event = event
    }
}
