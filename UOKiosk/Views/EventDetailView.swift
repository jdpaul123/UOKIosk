//
//  EventDetailView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    
    var body: some View {
        ScrollView {
            VStack {
                Image.init(uiImage: event.image ?? UIImage())
                    .resizable()
                    .scaledToFit()
                Text(event.description)
                Text(event.address)
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(event.title).font(.headline)
                }
            }
        }
        
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventDetailView(event: Event.sampleEventData[0])
        }
    }
}
