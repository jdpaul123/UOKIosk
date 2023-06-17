//
//  EventsListCellView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import SwiftUI

struct EventsListCellView: View {
    @StateObject var vm: EventsListCellViewModel

    // MARK: INITIALIZER
    init(injector: Injector, event: IMEvent) {
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeEventsListCellViewModel(event: event))
    }

    var body: some View {
        HStack {
            Image.init(uiImage: (UIImage(data: vm.imageData ?? Data()) ?? UIImage(named: "NoImage")!))
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            VStack(alignment: .leading) {
                Text(vm.title)
            }
            Spacer()
        }
        .frame(height: 80)
    }
}

//struct EventsListCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsListCellView(injector: Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService()), event: <#IMEvent#>)
//    }
//}
