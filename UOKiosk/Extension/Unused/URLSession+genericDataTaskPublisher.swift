//
//  URLSession+genericDataTaskPublisher.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/20/23.
//
// Source Code: https://github.com/pyartez/blog-samples
// Article: https://medium.com/p/35fc99a499b

/*
 Combine is a way to handle asynchronous events

 Publisher is like the company that sends you a magazine. Anytime the publisher publishes some new data, you can then use it in the app

 1. You get a monthly subscription package
 2. The company makes the package behind the scenes
 3. you get the packate at your front foor
 4. make sure the box isn't damaged
 5. open and make sure the item is correct
 6. use the item!!!
 7. subscription is cancelable at any time

 1. Create the publisher
 2. subscribe publisher on background thread
 3. revieve on main thread
 4. tryMap (check that the data is good)
 5. decode (decode data into PostModels
 6. sink (put the item into our app)
 7. store (cancel subscription if needed)
 */
//import Foundation
//import Combine
//
//extension URLSession {
//    enum SessionError: Error {
//        case statusCode(HTTPURLResponse)
//    }
//
//    /// Function that wraps the existing dataTaskPublisher method and attempts to decode the result and publish it
//    /// - Parameter request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on
//    /// - Returns: Publisher that sends a URLSession.Result if the response can be decoded correctly.
//    func dataTaskPublisher<T: Decodable>(for request: URLRequest) -> AnyPublisher<T, Error> {
//        return self.dataTaskPublisher(for: request)
//            .tryMap({ (data, response) -> Data in
//                if let response = response as? HTTPURLResponse,
//                    (200..<300).contains(response.statusCode) == false {
//                    throw SessionError.statusCode(response)
//                }
//
//                return data
//            })
//            .decode(type: T.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//
//    /// Function that wraps the existing dataTaskPublisher method and attempts to decode the result and publish it
//    /// - Parameter url: The URL to be retrieved.
//    /// - Returns: Publisher that sends a URLSession.Result if the response can be decoded correctly.
//    func dataTaskPublisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
//        return self.dataTaskPublisher(for: url)
//            .tryMap({ (data, response) -> Data in
//                if let response = response as? HTTPURLResponse,
//                    (200..<300).contains(response.statusCode) == false {
//                    throw SessionError.statusCode(response)
//                }
//
//                return data
//            })
//            .decode(type: T.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//}
