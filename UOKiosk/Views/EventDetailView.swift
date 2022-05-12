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
        VStack {
            Text(event.title)
            Text(event.address)
        }
        
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Event.sampleEventData[0])
    }
}
