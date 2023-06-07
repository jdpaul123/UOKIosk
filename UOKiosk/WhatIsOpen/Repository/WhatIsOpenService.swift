//
//  WhatIsOpenService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/6/23.
//

import Foundation

class WhatIsOpenService {
    func getAssetData(url: String) async throws -> WhatIsOpenViewModel {
        // get the data from the ApiService. Turn the returned Dto object into a view model so that the data can be displayed
        var whatIsOpenDto: WhatIsOpenDto? = nil
        do {
            whatIsOpenDto = try await ApiService.shared.getJSON(urlString: url)
        } catch {
            fatalError("FAILED TO GET THE DATA WITH ERROR")
        }

        // Go through each new "Asset"
        // Create the current asset's

        return WhatIsOpenViewModel(dining: [], coffee: [], duckStore: [], recreation: [], library: [], closed: [])
    }
}
