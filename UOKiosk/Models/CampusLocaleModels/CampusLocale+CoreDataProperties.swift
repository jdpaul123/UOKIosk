//
//  CampusLocale+CoreDataProperties.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/15/23.
//
//

import Foundation
import CoreData


extension CampusLocale {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CampusLocale> {
        return NSFetchRequest<CampusLocale>(entityName: "CampusLocale")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var storeHours: NSSet?

}

// MARK: Generated accessors for storeHours
extension CampusLocale {

    @objc(addStoreHoursObject:)
    @NSManaged public func addToStoreHours(_ value: HoursOfOperation)

    @objc(removeStoreHoursObject:)
    @NSManaged public func removeFromStoreHours(_ value: HoursOfOperation)

    @objc(addStoreHours:)
    @NSManaged public func addToStoreHours(_ values: NSSet)

    @objc(removeStoreHours:)
    @NSManaged public func removeFromStoreHours(_ values: NSSet)

}

extension CampusLocale : Identifiable {

}
