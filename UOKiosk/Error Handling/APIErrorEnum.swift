//
//  APIErrorEnum.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/18/23.
//

import Foundation

// MARK: - APIError Enumeration
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The APIO failed to issue a valid response. Check internet connection.", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
