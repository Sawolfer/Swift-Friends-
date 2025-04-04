//
//  EventViewProtocol.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import UIKit

protocol EventViewProtocol: AnyObject {
    func showEvents(events: [EventModels.Event])
    func showArchiveEvents(events: [EventModels.Event])
    func updateEvent(at index: Int, event: EventModels.Event)
    func moveEventToArchive(event: EventModels.Event, from index: Int)
    func moveEventFromArchive(event: EventModels.Event, from index: Int)
    func displayAddEventViewController(_ viewController: UIViewController)
    func displayViewEventViewController(_ viewController: UIViewController)
}
