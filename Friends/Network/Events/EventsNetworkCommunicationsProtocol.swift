//
//  EventsNetworkCommunicationsProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 31.03.2025.
//

import Foundation

protocol EventsNetworkCommunicationsProtocol {
    func loadEvents(completion: @escaping ([EventModels.Event]) -> Void)
    func addEvent(_ event: EventModels.Event)
    func updateAttendance(
        eventId: String, userId: String, status: EventModels.AttendanceStatus)
    func updateEvent(_ event: EventModels.Event)
    func deleteEvent(eventId: String)
}
