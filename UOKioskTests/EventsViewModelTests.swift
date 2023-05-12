//
//  EventsViewModelTests.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 5/11/23.
//

import XCTest
@testable import UOKiosk


// MARK: Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// MARK: Naming Structure: test_[Struct, Class, or Enum]_[variable or function]_[expected result]
// MARK: Testing Structure: Given, When, Then

final class EventsViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_EventsViewModel_id_exists() {
        // Given

        // When
        let vm = EventsViewModel(eventsRepository: MockEventsService())

        // Then
        XCTAssertNotNil(vm.id)
    }

    func test_EventsViewModel_isLoading_false() {
        // Given
        let isLoading = false

        // When
        _ = EventsViewModel(eventsRepository: MockEventsService(), isLoading: isLoading)

        // Then
        XCTAssertFalse(isLoading)
    }

    func test_EventsViewModel_isLoading_true() {
        // Given
        let isLoading = true

        // When
        _ = EventsViewModel(eventsRepository: MockEventsService(), isLoading: isLoading)

        // Then
        XCTAssertTrue(isLoading)
    }

    func test_EventsViewModel_showAlert_false() {
        // Given
        let showAlert = false

        // When
        _ = EventsViewModel(eventsRepository: MockEventsService(), showAlert: showAlert)

        // Then
        XCTAssertFalse(showAlert)
    }

    func test_EventsViewModel_showAlert_true() {
        // Given
        let showAlert = true

        // When
        _ = EventsViewModel(eventsRepository: MockEventsService(), showAlert: showAlert)

        // Then
        XCTAssertTrue(showAlert)
    }

    func test_EventsViewModel_errorMessage_shouldBeInjectedValue() {
        // Given
        let errorMessage = UUID().uuidString

        // When
        let vm = EventsViewModel(eventsRepository: MockEventsService(), errorMessage: errorMessage)

        // Then
        XCTAssertEqual(vm.errorMessage, errorMessage)
    }

    func test_EventsViewModel_errorMessage_shouldBeInjectedNil() {
        // Given
        let errorMessage: String? = nil

        // When
        let vm = EventsViewModel(eventsRepository: MockEventsService(), errorMessage: errorMessage)

        // Then
        XCTAssertEqual(vm.errorMessage, errorMessage)
    }

    func test_EventsViewModel_errorMessage_shouldBeDefaultNil() {
        // Given
        let errorMessage: String? = nil

        // When
        let vm = EventsViewModel(eventsRepository: MockEventsService())

        // Then
        XCTAssertEqual(vm.errorMessage, errorMessage)
    }

    func test_EventsViewModel_eventsInADay_shouldBeEmpty() {
        // Given

        // When
        let vm = EventsViewModel(eventsRepository: MockEventsService())

        // Then
        XCTAssertTrue(vm.eventsInADay.isEmpty)
        XCTAssertEqual(vm.eventsInADay.count, 0)
    }

    // TODO: Tests to write
    /*
     eventsInADay has items
     MOCK eventsRepository.fetchNewEvents() method to return Events data so that we can test the fetchEvents method in EventsViewModel
     Set eventsRepository and resultsController and lastDataUpdateDate to be private(set) so that we can test those properties values
     */
}
