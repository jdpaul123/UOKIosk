//
//  ApiService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import Foundation
import Combine

// MARK: - API Service Protocol
protocol ApiServiceProtocol {
    func getJSON<T: Decodable>(urlString: String,
                               dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
                               keyDecodingStrategy:JSONDecoder.KeyDecodingStrategy) async throws -> T
}

// MARK: - API Service
class ApiService: ApiServiceProtocol {
    /*
     This is a general API Service that can call any JSON Web API and fill the JSON data into
     a conforming, generic, decodable Swift object.
     */

    // Code source: https://www.youtube.com/watch?v=5oBiSNnSvdQ&list=RDCMUC2D6eRvCeMtcF5OGHf1-trw&index=4 Swift Concurrency Lesson 4 - Async and Await by CodeWithChris Ft. Stewart Lynch
    // TODO: Impliment getJSON with Combine: https://www.youtube.com/watch?v=fdxFp5vU6MQ&t=9s
    func getJSON<T: Decodable>(urlString: String,
                               dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponseStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }

    // MARK: Singleton
    static let shared = ApiService()
}

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
