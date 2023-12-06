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
    final class EventKitViewControllerMock: EventKitViewProtocol {
        var eventCreated: Bool
        var eventStore: EKEventStore
        var event: EKEvent

        init() {
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
        sut = EventKitView.Coordinator(EventKitViewControllerMock())
    }

    override func tearDownWithError() throws {
        sut = nil
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
