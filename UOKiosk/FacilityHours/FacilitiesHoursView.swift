//
//  FacilityHoursView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/18/23.
//

import SwiftUI

struct WhatIsOpenView: View {
    let injector: Injector
    @StateObject var vm: WhatIsOpenViewModel

    // MARK: INITIALIZER
    init(injector: Injector) {
        self.injector = injector
        _vm = StateObject(wrappedValue: injector.viewModelFactory.makeWhatIsOpenViewModel())
    }

    var body: some View {
        List($vm.dining) { $restauraunt in
            DisclosureGroup( isExpanded: $restauraunt.isExpanded) {
                VStack {
                    HStack {
                        Text(restauraunt.note ?? "")
                        Spacer()
                    }
                }
            } label: {
                Text(restauraunt.name)
            }
        }
    }
}

struct FacilitiesHoursView_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsOpenView(injector: Injector(eventsRepository: MockEventsService()))
    }
}
