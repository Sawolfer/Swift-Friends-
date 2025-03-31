//
//  DataManager.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import MapKit

final class DataManager: DataManagerProtocol {
    // MARK: - Properties

    private var events: [EventModel] = [
        EventModel(
            title: "Coffee",
            address: "Surf Coffee",
            date: "15:15 Mar 27",
            location: CLLocationCoordinate2D(latitude: 43.395452, longitude: 39.973114),
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 43.395452, longitude: 39.973114),
                latitudinalMeters: 250,
                longitudinalMeters: 250
            ),
            friendsImages: [UIImage(named: "image")],
            status: .awaiting
        ),
        EventModel(
            title: "Coffee",
            address: "Surf Coffee",
            date: "15:15 Mar 27",
            location: CLLocationCoordinate2D(latitude: 43.395452, longitude: 39.973114),
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 43.395452, longitude: 39.973114),
                latitudinalMeters: 250,
                longitudinalMeters: 250
            ),
            friendsImages: [UIImage(named: "image")],
            status: .awaiting
        ),
        EventModel(
            title: "Coffee",
            address: "Surf Coffee",
            date: "15:15 Mar 27",
            location: CLLocationCoordinate2D(latitude: 43.395452, longitude: 39.973114),
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 43.395452, longitude: 39.973114),
                latitudinalMeters: 250,
                longitudinalMeters: 250
            ),
            friendsImages: [UIImage(named: "image")],
            status: .awaiting
        )
    ]
    private var archive: [EventModel] = []

    // MARK: - Functions

    func loadEvents() -> [EventModel] {
        return events
    }

    func addEvent(_ event: EventModel) {
        events.append(event)
    }
    func updateEventStatus(status: GoingStatus, at index: Int) {
        events[index].status = status
    }

    func loadArchive() -> [EventModel] {
        return archive
    }

    func moveToArchive(eventIndex: Int) {
        guard eventIndex >= 0 && eventIndex < events.count else { return }
        var event = events.remove(at: eventIndex)
        event.status = .declined
        archive.append(event)
    }

    func restoreFromArchive(eventIndex: Int) {
        guard eventIndex >= 0 && eventIndex < archive.count else { return }
        var event = archive.remove(at: eventIndex)
        event.status = .going
        events.append(event)
    }
}
