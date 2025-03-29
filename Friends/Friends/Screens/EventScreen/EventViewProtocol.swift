//
//  EventViewProtocol.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//

protocol EventViewProtocol: AnyObject {
    // MARK: Functions
    func showEvents(events: [EventModel])
    func showArchiveEvents(events: [EventModel])
    func updateEvent(at index: Int, event: EventModel)
    func moveEventToArchive(event: EventModel, from index: Int)
    func moveEventFromArchive(event: EventModel, from index: Int)
}
