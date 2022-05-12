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
                .scaledToFit()
                .frame(width: 100)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            VStack(alignment: .leading){
                Text(event.title)
            }
            Spacer()
        }
        .frame(height: 80)
    }
}

struct EventListItemView_Previews: PreviewProvider {
    static var previews: some View {
        EventListItemView(event: Event.sampleEventData[0])
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
