//
//  EventKitViewCoordinatorTests.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 12/5/23.
//

import XCTest
@testable import UOKiosk
import EventKitUI

final class EventKitViewCoordinatorTests: XCTestCase {
    // Make this NSObject to make it equateable: This should compair the memory locaitons (aka. pointer equality) of the two objects
    // Discusion: https://thenewt.medium.com/equatable-pitfalls-in-ios-d250534bd7cc#:~:text=First%20of%20all%2C%20NSObject%20already,objects%20using%20the%20%3D%3D%20operator.&text=isEqual%20checks%20for%20pointer%20equality,NSObject%27s%20default%20implementation%20for%20%3D%3D%3D%20.
    final class MockEventKitViewController: NSObject, EventKitViewProtocol {
        var eventCreated: Bool
        var eventStore: EKEventStore
        var event: EKEvent

        override init() {
            eventCreated = false
            eventStore = EventStoreMock()
            event = EKEvent(eventStore: eventStore)
        }
    }

    final class EventStoreMock: EKEventStore {
        override func save(_ event: EKEvent, span: EKSpan) throws {}
    }

    var sut: EventKitView.Coordinator?

    override func setUpWithError() throws {
        sut = EventKitView.Coordinator(MockEventKitViewController())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_Coordinator_Init_SavedProperties() {
        // given
        let parent = MockEventKitViewController()

        // when
        sut = EventKitView.Coordinator(parent)

        // then
        XCTAssertEqual(parent, sut?.parent as? MockEventKitViewController)
    }

    func test_Coordinator_EventEditViewController_Saved() {
        // Given
        guard let sut = sut else {
            XCTFail()
            return
        }

        // When
        sut.eventEditViewController(EKEventEditViewController(), didCompleteWith: .saved)

        // Then
        XCTAssertTrue(sut.parent.eventCreated)
    }

}
