//
//  MockWhatIsOpenService.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 6/8/23.
//

import Foundation

class MockWhatIsOpenService: WhatIsOpenRepository {
    func getAssetData() async throws -> [WhatIsOpenCategories : [PlaceViewModel]] {
        return [.bank:[]]
    }
}
