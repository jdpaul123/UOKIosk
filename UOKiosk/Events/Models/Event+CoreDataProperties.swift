//
//  Event+CoreDataProperties.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    // MARK: Instance properties
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var eventDescription: String
    @NSManaged public var locationName: String?
    @NSManaged public var roomNumber: String?
    @NSManaged public var address: String?
    @NSManaged public var status: String?
    @NSManaged public var experience: String?
    @NSManaged public var eventUrl: URL?
    @NSManaged public var streamUrl: URL?
    @NSManaged public var ticketUrl: URL?
    @NSManaged public var venueUrl: URL?
    @NSManaged public var calendarUrl: URL?
    @NSManaged public var photoData: Data?
    @NSManaged public var photoUrl: URL?
    @NSManaged public var ticketCost: String?
    @NSManaged public var start: Date
    @NSManaged public var end: Date?
    @NSManaged public var allDay: Bool
    @NSManaged public var eventLocation: EventLocation?
    @NSManaged public var departmentFilters: NSSet?
    @NSManaged public var targetAudienceFilters: NSSet?
    @NSManaged public var eventTypeFilters: NSSet?

}

// MARK: Generated accessors for departmentFilters
extension Event {

    @objc(addDepartmentFiltersObject:)
    @NSManaged public func addToDepartmentFilters(_ value: EventFilter)

    @objc(removeDepartmentFiltersObject:)
    @NSManaged public func removeFromDepartmentFilters(_ value: EventFilter)

    @objc(addDepartmentFilters:)
    @NSManaged public func addToDepartmentFilters(_ values: NSSet)

    @objc(removeDepartmentFilters:)
    @NSManaged public func removeFromDepartmentFilters(_ values: NSSet)

}

// MARK: Generated accessors for targetAudienceFilters
extension Event {

    @objc(addTargetAudienceFiltersObject:)
    @NSManaged public func addToTargetAudienceFilters(_ value: EventFilter)

    @objc(removeTargetAudienceFiltersObject:)
    @NSManaged public func removeFromTargetAudienceFilters(_ value: EventFilter)

    @objc(addTargetAudienceFilters:)
    @NSManaged public func addToTargetAudienceFilters(_ values: NSSet)

    @objc(removeTargetAudienceFilters:)
    @NSManaged public func removeFromTargetAudienceFilters(_ values: NSSet)

}

// MARK: Generated accessors for eventTypeFilters
extension Event {

    @objc(addEventTypeFiltersObject:)
    @NSManaged public func addToEventTypeFilters(_ value: EventFilter)

    @objc(removeEventTypeFiltersObject:)
    @NSManaged public func removeFromEventTypeFilters(_ value: EventFilter)

    @objc(addEventTypeFilters:)
    @NSManaged public func addToEventTypeFilters(_ values: NSSet)

    @objc(removeEventTypeFilters:)
    @NSManaged public func removeFromEventTypeFilters(_ values: NSSet)

}

extension Event : Identifiable {

}
