//
//  MockWhatIsOpenService.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 6/8/23.
//

import Foundation
@testable import UOKiosk

class MockWhatIsOpenService: WhatIsOpenRepository {
    func getAssetData() async throws -> [WhatIsOpenCategories : [WhatIsOpenPlace]] {
        return [.bank:[]]
    }
}
