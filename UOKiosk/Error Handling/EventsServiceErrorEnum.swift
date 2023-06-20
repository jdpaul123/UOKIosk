//
//  EventsServiceErrorEnum.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/18/23.
//

import Foundation

// MARK: - EventsServiceError Enumeration
enum EventsServiceError: Error, LocalizedError {
    case dataTransferObjectIsNil

    var errorDescription: String? {
        switch self {
        case .dataTransferObjectIsNil:
            return NSLocalizedString("The api did not return the data transfer object", comment: "")
        }
    }
}
