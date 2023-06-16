//
//  EventsListCellViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation

class EventsListCellViewModel: ObservableObject {
    @Published var imageData: Data
    @Published var title: String

    init(imageData: Data, title: String) {
        self.imageData = imageData
        self.title = title
    }
}
