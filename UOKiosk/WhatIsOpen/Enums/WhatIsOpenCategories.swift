//
//  WhatsOpenEnums.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/8/23.
//

import Foundation

enum WhatIsOpenCategories: String, CaseIterable {
    case dining, coffee, recreation, library, grocery, building, bank, other, closed
    case duckStore = "duck store"

    func getWhatIsOpenViewModelData(vm: WhatIsOpenViewModel) -> Published<[WhatIsOpenPlace]>.Publisher {
        switch self {
        case .dining:
            return vm.$dining
        case .coffee:
            return vm.$coffee
        case .recreation:
            return vm.$recreation
        case .library:
            return vm.$library
        case .grocery:
            return vm.$grocery
        case .building:
            return vm.$building
        case .bank:
            return vm.$bank
        case .other:
            return vm.$other
        case .closed:
            return vm.$closed
        case .duckStore:
            return vm.$duckStore
        }
    }
}
