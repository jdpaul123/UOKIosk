//
//  WhatIsOpenMapView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/14/23.
//

import SwiftUI

struct WhatIsOpenMapView: View {
    @StateObject var vm: WhatIsOpenMapViewModel

    // MARK: INITIALIZER
    init(vm: WhatIsOpenMapViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        vm.campusMapWebViewRepresentable
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.campusMapWebViewRepresentable.reloadHome()
                } label: {
                    Image(systemName: "house")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.campusMapWebViewRepresentable.reload()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .banner(data: $vm.bannerData, show: $vm.showBanner)
    }
}

struct WhatIsOpenMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WhatIsOpenMapView(vm: WhatIsOpenMapViewModel(url: URL(string: "https://map.uoregon.edu/307a16180")!))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
