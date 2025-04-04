//
//  EventPresenterProtocol.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import UIKit

protocol EventPresenterProtocol: AnyObject {
    func viewLoaded()
    func numberOfEvents() -> Int
    func numberOfArchived() -> Int
    func configureEvent(cell: EventCell, at index: Int)
    func configureArchived(cell: EventCell, at index: Int)
    func didAcceptEvent(at index: Int)
    func didDeclineEvent(at index: Int)
    func didRestoreEventFromArchive(at index: Int)
    func didSelectEvent(at index: Int)
    func addEvent()
}
