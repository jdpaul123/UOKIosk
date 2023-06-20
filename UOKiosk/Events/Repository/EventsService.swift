//
//  EventsService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//

import Foundation

class EventsService: EventsRepository {
    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    func getFreshEvents() async throws -> [IMEvent] {
        var dto: EventsDto? = nil
        do {
            dto = try await ApiService.shared.getJSON(urlString: urlString)
        } catch {
            throw error
        }

        guard let dto = dto else {
            throw EventsServiceError.dataTransferObjectIsNil
        }

        var eventDtos = [EventDto]()
        // If an event loaded in has an id that does not equate to any of the id's on the events already saved, then add the event to the persistent store
        for middleLayer in dto.eventMiddleLayerDto {
            let eventDto = middleLayer.eventDto
            // Make sure there is date info for the event and that the object has a start date
            guard let eventInstanceWrapper = eventDto.eventInstances?[0], eventInstanceWrapper.eventInstance.start != "" else {
                continue
            }

            let dateValues = getEventInstanceDateData(dateData: eventInstanceWrapper.eventInstance)
            let allDay = dateValues.0
            let _ = dateValues.1
            let end = dateValues.2
            if allDay == true {
                // If the event is all day then we should save it
                eventDtos.append(eventDto)
            }
            guard let end = end else {
                // If the event is not all day, but we do not know when it ends, then we should save it
                eventDtos.append(eventDto)
                continue
            }
            if end < Date() {
                // If the event is already over then we should not save it
                continue
            }
            // If the event is not all day, but the end of the event is in the future then save it
            eventDtos.append(eventDto)
        }

        var events = [IMEvent]()
        for eventDto in eventDtos {
            guard let eventInstances = eventDto.eventInstances else {
                fatalError("There are no event instances to access")
            }
            let dateData = eventInstances[0].eventInstance
            let dateValues = getEventInstanceDateData(dateData: dateData)

            var eventTypeFilters = [IMEventFilter]()
            var departmentFilters = [IMEventFilter]()
            var targetAudienceFilters = [IMEventFilter]()
            if let dtoEventFilters = eventDto.filters.eventTypes {
                for eventFilter in dtoEventFilters {
                    eventTypeFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name))
                }
            }
            if let dtoDepartmentFilters = eventDto.filters.departments {
                for eventFilter in dtoDepartmentFilters {
                    departmentFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name))
                }
            }
            if let dtoTargetAudienceFilters = eventDto.filters.eventTargetAudience {
                for eventFilter in dtoTargetAudienceFilters {
                    targetAudienceFilters.append(IMEventFilter(id: eventFilter.id, name: eventFilter.name))
                }
            }

            let event = IMEvent(id: eventDto.id, title: eventDto.title, eventDescription: eventDto.descriptionText, locationName: eventDto.locationName,
                                roomNumber: eventDto.roomNumber, address: eventDto.address, status: eventDto.status, experience: eventDto.experience,
                                eventUrl: URL(string: eventDto.localistUrl ?? ""),
                                streamUrl: URL(string: eventDto.streamUrl ?? ""),
                                ticketUrl: URL(string: eventDto.ticketUrl ?? ""),
                                venueUrl: URL(string: eventDto.venueUrl ?? ""),
                                calendarUrl: URL(string: eventDto.icsUrl ?? ""),
                                photoUrl: URL(string: eventDto.photoUrl ?? ""),
                                photoData: nil, // photo data is loaded asyncronously after instantiation
                                ticketCost: eventDto.ticketCost,
                                start: dateValues.1, end: dateValues.2, allDay: dateValues.0,
                                departmentFilters: departmentFilters, targetAudienceFilters: targetAudienceFilters, eventTypeFilters: eventTypeFilters)
            events.append(event)
        }

        return events // TODO: Above this return, once Core Data is implimented add in a check that fetchedObjects exists and has Events, otherwise Throw an error
    }

    private func getEventInstanceDateData(dateData: EventInstanceDto) -> (Bool, Date, Date?) {
        let startStr: String = dateData.start
        let endStr: String? = dateData.end

        // Format the start and end dates if they exist
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d'T'HH:mm:ssZ"
        let start: Date
        let end: Date?

        start = {
            guard let date = dateFormatter.date(from: startStr) else {
                fatalError("Start date could not be determined form the provided date string")
            }
            return date
        }()

        if let endStr = endStr {
            end = dateFormatter.date(from: endStr)
        } else {
            end = nil
        }

        let allDay = dateData.allDay
        return (allDay, start, end)
    }
}
