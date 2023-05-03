//
//  EventFilter+CoreDataProperties.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData


extension EventFilter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventFilter> {
        return NSFetchRequest<EventFilter>(entityName: "EventFilter")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var departmentEvents: NSSet?
    @NSManaged public var targetAudienceEvents: NSSet?
    @NSManaged public var eventTypeEvents: NSSet?

}

// MARK: Generated accessors for departmentEvents
extension EventFilter {

    @objc(addDepartmentEventsObject:)
    @NSManaged public func addToDepartmentEvents(_ value: Event)

    @objc(removeDepartmentEventsObject:)
    @NSManaged public func removeFromDepartmentEvents(_ value: Event)

    @objc(addDepartmentEvents:)
    @NSManaged public func addToDepartmentEvents(_ values: NSSet)

    @objc(removeDepartmentEvents:)
    @NSManaged public func removeFromDepartmentEvents(_ values: NSSet)

}

// MARK: Generated accessors for targetAudienceEvents
extension EventFilter {

    @objc(addTargetAudienceEventsObject:)
    @NSManaged public func addToTargetAudienceEvents(_ value: Event)

    @objc(removeTargetAudienceEventsObject:)
    @NSManaged public func removeFromTargetAudienceEvents(_ value: Event)

    @objc(addTargetAudienceEvents:)
    @NSManaged public func addToTargetAudienceEvents(_ values: NSSet)

    @objc(removeTargetAudienceEvents:)
    @NSManaged public func removeFromTargetAudienceEvents(_ values: NSSet)

}

// MARK: Generated accessors for eventTypeEvents
extension EventFilter {

    @objc(addEventTypeEventsObject:)
    @NSManaged public func addToEventTypeEvents(_ value: Event)

    @objc(removeEventTypeEventsObject:)
    @NSManaged public func removeFromEventTypeEvents(_ value: Event)

    @objc(addEventTypeEvents:)
    @NSManaged public func addToEventTypeEvents(_ values: NSSet)

    @objc(removeEventTypeEvents:)
    @NSManaged public func removeFromEventTypeEvents(_ values: NSSet)

}

extension EventFilter : Identifiable {

}
