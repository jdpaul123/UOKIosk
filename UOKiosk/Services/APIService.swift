//
//  ApiService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import Foundation

// TODO: call it eventsService
protocol ApiServiceProtocol {
    // Call it loadEvents
    func loadApiData<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void)
}

// You only want one of these so make it a reference type
class ApiService: ApiServiceProtocol {
    /*
     This is a general API Service that can call any JSON Web API and fill the JSON data into
     a conforming, generic, decodable Swift object.
     */
    enum APIErros: Error {
        case UrlStringToUrlTypeError
        case UrlToDataObjectError
        case DataToObjectTDecodingError
    }
    
    /*
    // Often, if the top level model object is just an object with an array of objects you can set the variable to the list
    // attribute in the class T return value from this function
    func loadApiData<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) async {
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
     */
    
    func loadApiData<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
        // Try to turn the url string into a Swift URL struct instance
        guard let url = URL(string: urlString) else {
            print("URL String could not be converted to a Swift URL object.")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data, error == nil else {
                var fatalErrorString = ""
                if let errorStr = error?.localizedDescription {
                    fatalErrorString = errorStr
                } else {
                    fatalErrorString = "data that was returned was nil"
                }
                fatalError(fatalErrorString)
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

        task.resume()
    }
    
    // MARK: Singleton
    static let shared = ApiService()
}
