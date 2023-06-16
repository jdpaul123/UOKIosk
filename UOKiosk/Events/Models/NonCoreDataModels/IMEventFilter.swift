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

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
