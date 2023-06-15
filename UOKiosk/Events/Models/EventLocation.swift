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
        
        self.latitude = Double(geoData.latitude ?? "0.0") ?? 0.0
        self.longitude = Double(geoData.longitude ?? "0.0") ?? 0.0
        self.street = geoData.street ?? ""
        self.city = geoData.city ?? ""
        self.country = geoData.country ?? ""
        self.zip = Int64(geoData.zip ?? "0") ?? Int64(0)
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
