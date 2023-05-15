//
//  HoursOfOperation+CoreDataProperties.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/15/23.
//
//

import Foundation
import CoreData


extension HoursOfOperation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HoursOfOperation> {
        return NSFetchRequest<HoursOfOperation>(entityName: "HoursOfOperation")
    }

    @NSManaged public var day: String?
    @NSManaged public var openTime: String?
    @NSManaged public var closeTime: String?
    @NSManaged public var campusLocale: CampusLocale?

}

extension HoursOfOperation : Identifiable {

}
