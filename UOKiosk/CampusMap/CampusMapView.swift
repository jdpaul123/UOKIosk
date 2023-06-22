//
//  CampusMapView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/20/23.
//

import SwiftUI

// TODO: Ask for location permissions at the instantiation of the view
struct CampusMapView: View {
    var viewRepresentable = CampusMapWebViewRepresentable(url: URL(string: "https://map.uoregon.edu")!)

    var body: some View {
        viewRepresentable
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("INFO")
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewRepresentable.view.load(URLRequest(url: URL(string: "https://map.uoregon.edu")!))
                    } label: {
                        Image(systemName: "house")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewRepresentable.view.reload()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }

            }
    }
}

struct CampusMapView_Previews: PreviewProvider {
    static var previews: some View {
        CampusMapView()
    }
}
