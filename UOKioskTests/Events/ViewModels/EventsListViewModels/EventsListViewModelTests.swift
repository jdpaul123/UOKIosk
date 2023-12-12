//
//  EventsListViewModelTests.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 12/7/23.
//

import XCTest
@testable import UOKiosk
import CoreData

fileprivate class MockEventsRepository: NSObject, EventsRepository {
    var persistentContainer: NSPersistentContainer
    var fetchedResultsController = NSFetchedResultsController<Event>()
    var getImageCallCount = 0
    var fetchEventsCallCount = 0
    var fetchSavedEventsCallCount = 0

    init(urlString: String) {
        // Make sure the data is not persisted
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        persistentContainer = NSPersistentContainer(name: "EventsModel")
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]

        // NSMergeByPropertyObjectTrumpMergePolicy means that any object that is trying to add an Event Object with the same id as one already saved then it only updates the data rather than saving a second copy
        self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true

        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        super.init()
    }

    func getImage(event: UOKiosk.Event) {
        getImageCallCount += 1
    }

    func fetchEvents() async throws -> NSFetchedResultsController<Event>? {
        fetchEventsCallCount += 1
        return fetchedResultsController
    }

    func fetchSavedEvents() -> NSFetchedResultsController<Event>? {
        fetchSavedEventsCallCount += 1
        return fetchedResultsController
    }
}

// TODO: It seems this is not working for testing Events List View Model with data
fileprivate class MockEventsRepositoryWithData: MockEventsRepository {
    override init(urlString: String) {
        super.init(urlString: UUID().uuidString)

        // Add 5 events for testing purposes
        let _ = Event(id: 1, title: UUID().uuidString, eventDescription: UUID().uuidString, locationName: UUID().uuidString, roomNumber: UUID().uuidString, address: UUID().uuidString, status: UUID().uuidString, experience: UUID().uuidString, eventUrl: nil, streamUrl: nil, ticketUrl: nil, venueUrl: nil, calendarUrl: nil, photoData: nil, photoUrl: nil, ticketCost: UUID().uuidString, start: Date(), end: nil, allDay: false, eventLocation: nil, departmentFilters: [], targetAudienceFilters: [], eventTypeFilters: [], context: persistentContainer.viewContext)
        let _ = Event(context: persistentContainer.viewContext)
        let _ = Event(context: persistentContainer.viewContext)
        let _ = Event(context: persistentContainer.viewContext)
        let _ = Event(context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
    }
}

final class EventsListViewModelTests: XCTestCase {
    func test_EventsListViewModel_Init_SetsPropertiesCorrectly() {
        // given
        let eventsRepository = MockEventsRepository(urlString: UUID().uuidString)
        let bannerData = BannerModifier.BannerData(title: UUID().uuidString, detail: UUID().uuidString, type: .Success)
        let sut = EventsListViewModel(eventsRepository: eventsRepository, bannerData: bannerData)

        // then
        XCTAssertEqual(eventsRepository, sut.eventsRepository as? MockEventsRepository)
        XCTAssertEqual(sut.bannerData, bannerData)
        XCTAssertEqual(sut.eventsDictionary, [:])
        XCTAssertEqual(sut.events, [])
        XCTAssertEqual(sut.showingInformationSheet, false)
        XCTAssertEqual(sut.viewModelHasLoaded, false)
        XCTAssertEqual(sut.showBanner, false)
        XCTAssertEqual(sut.isLoading, false)
    }

    func test_EventsListViewModel_FetchEvents_SetsViewModelHasLoadedToTrue() async {
        // given
        let sut = EventsListViewModel(eventsRepository: MockEventsRepository(urlString: UUID().uuidString))

        // when
        await sut.fetchEvents()

        // then
        XCTAssertTrue(sut.viewModelHasLoaded)
    }

//    func test_EventsListViewModel_FetchEvents_ReturnsFiveEvents() async {
//        // given
//        let mockEventsRepository = MockEventsRepositoryWithData(urlString: UUID().uuidString)
//        let sut = EventsListViewModel(eventsRepository: MockEventsRepository(urlString: UUID().uuidString))
//        let eventsCount = sut.events.count
//
//        // when
//        await sut.fetchEvents()
//
//        // then
//        XCTAssertEqual(sut.events.count, eventsCount + 5)
//    }
}
