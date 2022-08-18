//
//  EventDetailView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import SwiftUI

struct EventDetailView: View {
    let injector: Injector
    @StateObject var viewModel: EventDetailViewModel
    
    init(_ event: EventModel, injector: Injector) {
        _viewModel = StateObject(wrappedValue: injector.viewModelFactory.makeEventDetailViewModel(eventModel: event))
        self.injector = injector
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailView()
//    }
//}
