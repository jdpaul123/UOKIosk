//
//  EventKitViewControllerTests.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 12/5/23.
//

import XCTest
@testable import UOKiosk
import EventKitUI

final class EventKitViewControllerTests: XCTestCase {
    func test_EventKitView_Init_ValuesAreCorrect() {
        // given
        let eventTitle = UUID().uuidString
        let eventDescription = UUID().uuidString
        let eventAllDay = false
        let eventStart = Date(timeIntervalSince1970: 0)
        let eventEnd = Date(timeIntervalSince1970: 100)
        let eventStore = EKEventStore() // Make partial mock for EKEventStore  if you expand into testing more than the init

        // when
        let sut = EventKitView(eventTitle: eventTitle, eventDescription: eventDescription, eventAllDay: eventAllDay, eventStart: eventStart, eventEnd: eventEnd,
                               eventStore: eventStore)

        // then
        XCTAssertEqual(eventTitle, sut.eventTitle)
        XCTAssertEqual(eventDescription, sut.eventDescription)
        XCTAssertEqual(eventAllDay, sut.eventAllDay)
        XCTAssertEqual(eventStart, sut.eventStart)
        XCTAssertEqual(eventEnd, sut.eventEnd)
        XCTAssertEqual(eventStore, sut.eventStore)
        XCTAssertEqual(false, sut.eventCreated)
    }

    // Don't test makeUIViewController and make sure all of the values are filled in for the vc because
    // UIViewControllerRepresentableContext (aka: Context) does not have any accessible initializers.
    // We can assume Apple has tested this method enough already
    // Nothing else to test
}
