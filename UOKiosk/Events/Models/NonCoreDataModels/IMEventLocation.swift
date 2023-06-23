//
//  IMEventLocation.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation

class IMEventLocation {
    let latitude: Double
    let longitude: Double
    let street: String?
    let city: String?
    let country: String?
    let zip: Int64
    weak var event: IMEvent?

    init(latitude: Double, longitude: Double, street: String?, city: String?, country: String?, zip: Int64, event: IMEvent?) {
        self.latitude = latitude
        self.longitude = longitude
        self.street = street
        self.city = city
        self.country = country
        self.zip = zip
        self.event = event
    }
}
