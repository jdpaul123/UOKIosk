//
//  MockApiService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/10/23.
//

import Foundation

class MockApiService: ApiServiceProtocol {
    // Gets a local JSON file and decoding it
    func getJSON<T: Decodable>(urlString: String,
                               dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T where T : Decodable {
        guard FileManager.default.fileExists(atPath: urlString) else {
            throw APIError.invalidURL
        }
        let url = URL(fileURLWithPath: urlString)
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
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
}
