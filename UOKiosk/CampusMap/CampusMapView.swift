//
//  CampusMapView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/20/23.
//

import SwiftUI

// TODO: Ask for location permissions at the instantiation of the view
struct CampusMapView: View {
    @StateObject var vm: CampusMapViewModel

    // MARK: INITIALIZER
    init(vm: CampusMapViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        vm.campusMapWebViewRepresentable
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.showingInformationSheet.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
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
            .sheet(isPresented: $vm.showingInformationSheet) {
                InformationView()
            }
            .banner(data: $vm.bannerData, show: $vm.showBanner)
    }
}

struct CampusMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CampusMapView(vm: CampusMapViewModel(url: URL(string: "https://map.uoregon.edu")!))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
