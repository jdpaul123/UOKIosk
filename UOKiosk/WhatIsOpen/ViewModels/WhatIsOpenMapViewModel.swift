//
//  WhatIsOpenMapViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/14/23.
//

import Foundation

class WhatIsOpenMapViewModel: ObservableObject {
    @Published var campusMapWebViewRepresentable: WhatIsOpenMapViewRepresentable
    @Published var showBanner: Bool = false
    // TODO: If the WebViewRepresentable cannot load (ex. internet connection fails), then show the error banner
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)

    init(url: URL) {
        campusMapWebViewRepresentable = WhatIsOpenMapViewRepresentable(url: url)
    }
}
