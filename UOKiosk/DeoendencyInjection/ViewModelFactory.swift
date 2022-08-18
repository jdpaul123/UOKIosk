//
//  ViewModelFactory.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/2/22.
//

import Foundation

final class ViewModelFactory: ObservableObject {
    private let eventsRepository: EventsRepository
    
    init(eventsRepository: EventsRepository) {
        self.eventsRepository = eventsRepository
    }
   
    func makeEventDetailViewModel(eventModel: EventModel) -> EventDetailViewModel {
        EventDetailViewModel(event: eventModel)
    }
    
    func makeEmptyEventsViewModel() -> EventsViewModel {
        EventsViewModel()
    } 
   
    func fillEventsViewModel(eventsViewModel: EventsViewModel) {
        eventsRepository.fetchEvents { (eventsModel: EventsModel?) in
            guard let eventsModel = eventsModel else {
                fatalError("Could not get events model")
            }
            // The view model contains data shown on the view so update it on the main thread
            DispatchQueue.main.async {
                eventsViewModel.fillData(eventsModel: eventsModel)
            }
        }
    }
        // TODO: DELETE THIS METHOD IF I AM NO LONGER USING IT
    //    func makeEventsViewModel(completion: @escaping ((EventsViewModel) -> Void)) {
//        var eventsViewModel: EventsViewModel? = nil
//
//        eventsRepository.fetchEvents { (eventsModel: EventsModel?) in
//            guard let eventsModel = eventsModel else {
//                fatalError("Could not get events model")
//            }
//            eventsViewModel = EventsViewModel(eventsModel: eventsModel)
//
//        }
//
//        guard let eventsViewModel = eventsViewModel else {
//            fatalError("Could not get events view model")
//        }
//
//        completion(eventsViewModel)
//    }
    
//    func makeWhatIsOpenViewModel() -> WhatIsOpenViewModel
}
