//
//  CampusMapView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/20/23.
//

import SwiftUI

// TODO: Ask for location permissions at the instantiation of the view
struct CampusMapView: View {
    var body: some View {
        CampusMapWebViewRepresentable(url: URL(string: "https://map.uoregon.edu")!)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CampusMapView_Previews: PreviewProvider {
    static var previews: some View {
        CampusMapView()
    }
}
