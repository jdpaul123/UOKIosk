//
//  EventLocation+CoreDataClass.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData

public class EventLocation: NSManagedObject {
    convenience init(geoDto: GeoDto, context: NSManagedObjectContext) {
        self.init(context: context)
        
        if let latString = geoDto.latitude, let latitude = Double(latString) {
            self.latitude = latitude
        }
        if let longString = geoDto.longitude, let longitude = Double(longString) {
            self.longitude = longitude
        }
        if let zipString = geoDto.zip, let zip = Int64(zipString) {
            self.zip = zip
        }
        self.street = geoDto.street
        self.city = geoDto.city
        self.country = geoDto.country
    }
}

// MARK: - Initializer for testing
extension EventLocation {
    convenience init(latitude: Double, longitude: Double, street: String, city: String, country: String, zip: Int, context: NSManagedObjectContext) {
        self.init(context: context)

        self.latitude = latitude
        self.longitude = longitude
        self.street = street
        self.city = city
        self.country = country
        self.zip = Int64(exactly: zip)!
    }
}
