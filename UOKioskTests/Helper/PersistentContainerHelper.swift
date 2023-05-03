//
//  PersistentContainerHelper.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 8/26/22.
//

import Foundation
import CoreData
@testable import UOKiosk

/*
class PersistentContainerHelper {
    func createPersistentContainer(shouldLoadStores: Bool = true) -> NSPersistentContainer {
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        storeDescription.shouldAddStoreAsynchronously = false

        let persistentContainer = NSPersistentContainer(name: "EventsModel", managedObjectModel: Injector(eventsRepository: <#T##EventsRepository#>).managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [storeDescription]

        if shouldLoadStores {
            persistentContainer.loadPersistentStores { _, error in
                guard error == nil else {
                    fatalError("Failed to load persistent stores for in memory persistent container: \(error!)")
                }
            }
        }

        return persistentContainer
    }

    // MARK: Properties
    static let shared = PersistentContainerHelper()
}
*/
