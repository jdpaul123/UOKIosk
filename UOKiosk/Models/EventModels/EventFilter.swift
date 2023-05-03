//
//  EventFilter+CoreDataClass.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/21/22.
//
//

import Foundation
import CoreData


public class EventFilter: NSManagedObject {
    convenience init(id: Int, name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int64(id)
        self.name = name
    }
}
