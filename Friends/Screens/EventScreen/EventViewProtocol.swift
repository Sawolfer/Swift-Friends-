//
//  EventViewProtocol.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import UIKit

protocol EventViewProtocol: AnyObject {
    func showEvents(events: [EventModel])
    func showArchiveEvents(events: [EventModel])
    func updateEvent(at index: Int, event: EventModel)
    func moveEventToArchive(event: EventModel, from index: Int)
    func moveEventFromArchive(event: EventModel, from index: Int)
    func displayAddEventViewController(_ viewController: UIViewController)
}
