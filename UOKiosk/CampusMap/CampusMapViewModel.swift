//
//  CampusMapViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/6/23.
//

import Foundation

class CampusMapViewModel: ObservableObject {
    @Published var campusMapWebViewRepresentable: CampusMapWebViewRepresentable
    @Published var showBanner: Bool = false
    // TODO: If the WebViewRepresentable cannot load (ex. internet connection fails), then show the error banner
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)
    @Published var showingInformationSheet: Bool = false

    init(url: URL) {
        campusMapWebViewRepresentable = CampusMapWebViewRepresentable(url: url)
    }
}
