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
    convenience init(geoData: GeoDto, context: NSManagedObjectContext) {
        self.init(context: context)
        
        if let latString = geoData.latitude, let latitude = Double(latString) {
            self.latitude = latitude
        } else {
            self.latitude = 0
        }
        if let longString = geoData.longitude, let longitude = Double(longString) {
            self.longitude = longitude
        } else {
            self.longitude = 0
        }
        if let zipString = geoData.zip, let zip = Int64(zipString) {
            self.zip = zip
        } else {
            self.zip = 0
        }
        self.street = geoData.street
        self.city = geoData.city
        self.country = geoData.country
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
