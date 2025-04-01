//
//  DataManagerProtocol.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//

protocol DataManagerProtocol {
    func loadEvents() -> [EventModel]
    func addEvent(_ event: EventModel)
    func updateEventStatus(status: GoingStatus, at index: Int)
    func loadArchive() -> [EventModel]
    func moveToArchive(eventIndex: Int)
    func restoreFromArchive(eventIndex: Int)
}
