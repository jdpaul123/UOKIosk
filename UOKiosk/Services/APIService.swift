//
//  GetJSON.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

import Foundation

struct APIService {
    enum APIErros: Error {
        case UrlStringToUrlTypeError
        case UrlToDataObjectError
        case DataToObjectTDecodingError
    }
    
    // Often, if the top level model object is just an object with an array of objects you can set the variable to the list
    // attribute in the class T return value from this function
    static func fetchJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) async {
        // Try to turn the url string into a Swift URL struct instance
        guard let url = URL(string: urlString) else {
            print("URL String could not be converted to a Swift URL object.")
            completion(nil)
            return
        }
        
        // Try to get the data from the url. If it fails, report the response
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            print("The URL at \(urlString) failed to be decoded into a Data object")
            completion(nil)
            return
        }

        let decoder = JSONDecoder()
        // Try to decode the object to the expected swift type object.
        guard let result = try? decoder.decode(T.self, from: data) else {
            print("Data failed to be decoded to the specified swift object")
            completion(nil)
            return
        }
      
        // In the case of a success, call the completion with the result
        print("The data was successfully decoded")
        //return result
        completion(result)
        return
    }
}
