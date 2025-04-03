//
//  DataManager.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import MapKit

final class DataManager: DataManagerProtocol {
    // MARK: - Properties

    private var eventNetworkManager: EventsNetworkCommunications
    private var events: [EventModels.Event] = []
    private var archive: [EventModels.Event] = []

    // MARK: - Initialization

    init(eventNetworkManager: EventsNetworkCommunications) {
        self.eventNetworkManager = eventNetworkManager
        loadEventsFromNetwork()
    }

    // MARK: - Functions

    func loadEvents() -> [EventModels.Event] {
        return events
    }

    func loadEventsFromNetwork() {
        eventNetworkManager.loadEvents { [weak self] loadedEvents in
            self?.events = loadedEvents
        }
    }

    func addEvent(_ event: EventModels.Event) {
        events.append(event)
    }

    func updateEventAttendanceStatus(status: EventModels.AttendanceStatus, at eventIndex: Int) {
        guard eventIndex >= 0 && eventIndex < events.count else { return }
        events[eventIndex].attendiesInfo[0].status = status
        eventNetworkManager.updateEvent(events[eventIndex])
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
