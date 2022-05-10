//
//  EventListItemView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/2/22.
//

import SwiftUI

struct EventListItemView: View {
    var event: Event
    var body: some View {
        HStack {
            Image("Deschutes")
                .resizable()
                .scaledToFill()
                .frame(width: 150)
                
            VStack(alignment: .leading){
                Text(event.title ?? "No title")
                Text(event.locationName ?? "No location")
            }
            Spacer()
        }
    }
}

struct EventListItemView_Previews: PreviewProvider {
    static var previews: some View {
        EventListItemView(event: Injector.sampleEventData[0])
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
