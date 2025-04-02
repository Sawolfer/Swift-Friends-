//
//  Event.swift
//  Friends
//
//  Created by тимур on 29.03.2025.
//

import UIKit

enum EventModels {
    struct Event: Codable {
        var id: UUID
        var title: String
        var description: String
        var address: String
        var date: Date
        var location: Location
        var hostId: UUID
        var invitedFriends: [UUID]
        var attendiesId: [UUID]
    }

    struct FriendInfo: Codable {
        var id: UUID
        var status: AttendanceStatus
        var pickedCellsForDate: [Date: [Int]]?
    }

    struct Location: Codable {
        var latitude: Float
        var longitude: Float
    }

    enum AttendanceStatus: String, Codable {
        case attending
        case declined
        case noReply
    }
}

extension EventModels.Event {
    static let empty: EventModels.Event = .init(
        id: UUID(),
        title: "",
        description: "",
        address: "",
        date: Date(),
        location: .init(latitude: 0, longitude: 0),
        hostId: UUID(),
        invitedFriends: [],
        attendiesId: []
    )
}
