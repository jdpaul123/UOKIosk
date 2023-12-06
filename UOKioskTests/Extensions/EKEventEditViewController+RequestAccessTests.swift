//
//  EKEventEditViewController+RequestAccessTests.swift
//  UOKioskTests
//
//  Created by Jonathan Paul on 12/6/23.
//

import XCTest
@testable import UOKiosk
import EventKitUI

// TODO: Currently, because the target iOS is less than iOS 17, these tests call requestAccess(to entityType: EKEntityType) async throws -> Bool rather than requestWriteOnlyAccessToEvents() async throws -> Bool, so once the low target is iOS 17.0 or above, update the tests

// Must be able to inject the MockEventStore instances in the tests
extension EKEventEditViewController {
    convenience init(eventStore: EKEventStore) {
        self.init()
        self.eventStore = eventStore
    }
}

final class EKEventEditViewController_RequestAccessTests: XCTestCase {
    class MockEventStore: EKEventStore {
        static var authStatus: EKAuthorizationStatus = .denied
        var isAccessAllowed: Bool // false if user denied. true if user accepted access

        init(authStatus: EKAuthorizationStatus, isAccessAllowed: Bool) {
            Self.authStatus = authStatus
            self.isAccessAllowed = isAccessAllowed
            super.init()
        }

        // Set to false if user accepted
        override class func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus {
            // TODO: Update for iOS 17.0 when you deprecate iOS 16
            return authStatus
        }

        // Set to false if user denied
        override func requestWriteOnlyAccessToEvents() async throws -> Bool {
            return isAccessAllowed
        }

        // Set to false if user denied
        override func requestAccess(to entityType: EKEntityType) async throws -> Bool {
            return isAccessAllowed
        }
    }


    // MARK: requestAccess() Tests
    func test_EKEventEditViewController_RequestAccessAuthorized_ShouldAllowAccessToAddEvents() async {
        // Given
        let eventStore = MockEventStore(authStatus: .authorized, isAccessAllowed: true)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertTrue(success)
    }

    @available(iOS 17.0, *)
    func test_EKEventEditViewController_RequestAccessWriteOnly_ShouldAllowAccessToAddEvents() async {
        // Given
        let eventStore = MockEventStore(authStatus: .writeOnly, isAccessAllowed: true)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertTrue(success)
    }

    @available(iOS 17.0, *)
    func test_EKEventEditViewController_RequestAccessFullAccess_ShouldAllowAccessToAddEvents() async {
        // Given
        let eventStore = MockEventStore(authStatus: .fullAccess, isAccessAllowed: true)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertTrue(success)
    }

    func test_EKEventEditViewController_RequestAccessNotDeterminedUserDenied_ShouldDenyAccessToAddEvents() async {
        // Given
        let eventStore = MockEventStore(authStatus: .notDetermined, isAccessAllowed: false)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertFalse(success)
    }

    func test_EKEventEditViewController_RequestAccessNotDeterminedUserAccepted_ShouldAllowAccessToAddEvents() async {
        // Given
        let eventStore = MockEventStore(authStatus: .notDetermined, isAccessAllowed: true)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertTrue(success)
    }

    func test_EKEventEditViewController_RequestAccessDeniedUserDenied_ShouldDenyAccessToAddEvents() async {
        // Given
        let eventStore = MockEventStore(authStatus: .denied, isAccessAllowed: false)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertFalse(success)
    }

    func test_EKEventEditViewController_RequestAccessDeniedUserApproved_ShouldAllowAccess() async {
        // Given
        let eventStore = MockEventStore(authStatus: .denied, isAccessAllowed: true)
        let sut = await EKEventEditViewController(eventStore: eventStore)

        // When
        let success: Bool?
        do {
            success = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            XCTFail("Failure Should not occur")
            return
        }

        // Then
        guard let success = success else {
            XCTFail("requestAccess() returned nil which it should not")
            return
        }
        XCTAssertTrue(success)
    }

    func test_EKEventEditViewController_RequestAccessRestricted_ShouldThrowPermissionError() async {
        // Given
        let eventStore = MockEventStore(authStatus: .restricted, isAccessAllowed: false)
        let sut = await EKEventEditViewController(eventStore: eventStore)
        let expectation = XCTestExpectation(description: "Make sure we come back with an error")

        // When
        do {
            _ = try await sut.requestAccess(eventStoreClass: MockEventStore.self)
        } catch {
            // Then
            XCTAssertEqual(error as? PermissionError, PermissionError.accessRestricted)
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }
}
