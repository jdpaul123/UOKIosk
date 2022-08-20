//
//  EventListItemView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import SwiftUI

struct EventListItemView: View {
    var event: EventsViewModelEvent
    var body: some View {
        HStack {
            Image.init(uiImage: event.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            VStack(alignment: .leading) {
                Text(event.title)
            }
            Spacer()
        }
        .frame(height: 80)
    }
}

#if DEBUG
struct EventListItemView_Previews: PreviewProvider {
    static var previews: some View {
        EventListItemView(event: EventsViewModelEvent(event: EventsModelExampleData().eventsModel.events[0]))
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
#endif
