//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/18/22.
//

import Foundation

final class EventsService: EventsRepository {
    /*
     This class will use the below attributes in tandem to get the chached events
     and load new ones from the api
     private let apiService: EventsApiServiceProtocol
     private let storageService: EventsStorageProtocol
     */
    var urlString: String

    // Defaults to the API service as its argument
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func fetchEvents(completion: @escaping (EventsModel?) -> Void) {
        ApiService.shared.loadApiData(urlString: urlString, completion: { (dto: EventsDto?) in
            var eventsModel: EventsModel? = nil
            guard let dto = dto else {
                print("failed to decode the apiService's html GET from the API")
                return
            }
            eventsModel = EventsModel(eventsData: dto)
            completion(eventsModel)
        })
    }
}
