//
//  DataManager.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import MapKit

final class DataManager: DataManagerProtocol {
    // MARK: - Properties

    private var events: [EventModels.Event] = []
    private var archive: [EventModels.Event] = []

    // MARK: - Functions

    func loadEvents() -> [EventModels.Event] {
        return events
    }

    func addEvent(_ event: EventModels.Event) {
        events.append(event)
    }

    func updateEventAttendanceStatus(status: EventModels.AttendanceStatus, at index: Int) {
        events[index].attendiesInfo[0].status = status
    }

    func loadArchive() -> [EventModels.Event] {
        return archive
    }

    func moveToArchive(eventIndex: Int) {
        guard eventIndex >= 0 && eventIndex < events.count else { return }
        let event = events.remove(at: eventIndex)
        events[eventIndex].attendiesInfo[0].status = .declined
        archive.append(event)
    }

    func restoreFromArchive(eventIndex: Int) {
        guard eventIndex >= 0 && eventIndex < archive.count else { return }
        let event = archive.remove(at: eventIndex)
        events[eventIndex].attendiesInfo[0].status = .attending
        events.append(event)
    }
}
