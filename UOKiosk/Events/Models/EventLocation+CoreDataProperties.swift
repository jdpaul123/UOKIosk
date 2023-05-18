//
//  EventLocation+CoreDataProperties.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData


extension EventLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventLocation> {
        return NSFetchRequest<EventLocation>(entityName: "EventLocation")
    }

    // MARK: Instance properties
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var street: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var zip: Int64
    @NSManaged public var event: Event?

}

extension EventLocation : Identifiable {

}
