//
//  EventsNetworkCommunications.swift
//  Friends
//
//  Created by Савва Пономарев on 31.03.2025.
//

import FirebaseFirestore
import Foundation

class EventsNetworkCommunications: EventsNetworkCommunicationsProtocol {
    private let firestore = Firestore.firestore()
    private let eventsCollection = "events"

    // MARK: - Events Logic

    func loadEvents(completion: @escaping ([EventModels.Event]) -> Void) {
        firestore.collection(eventsCollection).getDocuments { snapshot, error in
            if let error = error {
                print("Error loading events: \(error.localizedDescription)")
                completion([])
                return
            }
            let events = snapshot?.documents.compactMap { document -> EventModels.Event? in
                    try? document.data(as: EventModels.Event.self)
                } ?? []
            completion(events)
        }
    }
    func addEvent(_ event: EventModels.Event) {
        let eventRef = firestore.collection(eventsCollection).document(
            event.id.uuidString)
        do {
            try eventRef.setData(from: event)
            sendInvitations(for: event)
        } catch {
            print("Error adding event: \(error.localizedDescription)")
        }
    }
    func updateAttendance(
        eventId: String, userId: String, status: EventModels.AttendanceStatus
    ) {
        let eventRef = firestore.collection(eventsCollection).document(eventId)
        eventRef.updateData([
            "invitedFriends.\(userId).status": status.rawValue
        ]) { error in
            if let error = error {
                print(
                    "Error updating attendance: \(error.localizedDescription)")
            } else {
                self.notifyHost(
                    eventId: eventId, userId: userId, status: status)
            }
        }
    }
    func updateEvent(_ event: EventModels.Event) {
        let eventRef = firestore.collection(eventsCollection).document(
            event.id.uuidString)
        do {
            try eventRef.setData(from: event, merge: true)
            sendEditNotification(for: event)
        } catch {
            print("Error updating event: \(error.localizedDescription)")
        }
    }
    func deleteEvent(eventId: String) {
        firestore.collection(eventsCollection).document(eventId).delete { error in
            if let error = error {
                print("Error deleting event: \(error.localizedDescription)")
            } else {
                print("Event deleted successfully")
            }
        }
    }

    // MARK: - Notifications

    private func notifyHost(
        eventId: String, userId: String, status: EventModels.AttendanceStatus
    ) {
        let message =
            "User \(userId) has \(status == .attending ? "accepted" : "declined") your event."
        sendPushNotification(to: eventId, message: message)
    }
    private func sendInvitations(for event: EventModels.Event) {
        event.invitedFriends.forEach { friendId in
            let message = "You have been invited to the event \(event.title)."
            sendPushNotification(to: friendId.uuidString, message: message)
        }
    }
    private func sendEditNotification(for event: EventModels.Event) {
        event.invitedFriends.forEach { friendId in
            let message = "You have been invited to the event \(event.title)."
            sendPushNotification(to: friendId.uuidString, message: message)
        }
    }
    private func sendPushNotification(to userId: String, message: String) {
        let payload: [String: Any] = [
            "to": "/topics/\(userId)",
            "notification": [
                "title": "Event Update",
                "body": message
            ]
        ]
        // TODO: make temp realization via local notifications
        print("Sending push notification: \(payload)")
    }

}
