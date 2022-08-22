//
//  Events+CoreDataClass.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData
import SwiftUI


public class Events: NSManagedObject {
    convenience init(eventsData: EventsDto?, context: NSManagedObjectContext) {
        self.init(context: context)
        guard let eventsData = eventsData else {
            self.events = []
            print("The Events model did not recieve any data. It only recieved a nil value for the data (aka the Events DTO)")
            return
        }
        for middle in eventsData.eventMiddleLayerDto {
            self.events?.adding(Event(eventData: middle.eventDto, context: context))
        }
    }
}
