//
//  DataManagerProtocol.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//

protocol DataManagerProtocol {
    func loadEvents() -> [EventModels.Event]
    func addEvent(_ event: EventModels.Event)
    func updateEventAttendanceStatus(status: EventModels.AttendanceStatus, at index: Int)
    func loadArchive() -> [EventModels.Event]
    func moveToArchive(eventIndex: Int)
    func restoreFromArchive(eventIndex: Int)
}
