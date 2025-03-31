//
//  EventPresenter.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import MapKit

final class EventPresenter: EventPresenterProtocol {
    // MARK: - Properties
    weak var view: EventViewProtocol?
    var dataManager: DataManagerProtocol
    
    // MARK: - Initialization
    init(view: EventViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
    }
    
    // MARK: - Public funtions
    func viewLoaded() {
        loadInitialData()
    }
    
    func numberOfEvents() -> Int {
        return dataManager.loadEvents().count
    }
    
    func numberOfArchived() -> Int {
        return dataManager.loadArchive().count
    }
    
    func configureEvent(cell: EventCell, at index: Int) {
        let event = dataManager.loadEvents()[index]
        cell.configure(with: event)
    }
    
    func configureArchived(cell: EventCell, at index: Int) {
        let event = dataManager.loadArchive()[index]
        cell.configure(with: event)
    }
    
    func didSelectSegment(at index: Int) {
        // TODO: Настроить логика переключения между таблицами
    }
    
    func didAcceptEvent(at index: Int) {
        let event = dataManager.loadEvents()[index]
        dataManager.updateEventStatus(status: .going, at: index)
        view?.updateEvent(at: index, event: event)
    }
    
    func didDeclineEvent(at index: Int) {
        let event = dataManager.loadEvents()[index]
        dataManager.moveToArchive(eventIndex: index)
        view?.moveEventToArchive(event: event, from: index)
    }
    
    func didRestoreEventFromArchive(at index: Int) {
        let event = dataManager.loadArchive()[index]
        dataManager.restoreFromArchive(eventIndex: index)
        view?.moveEventFromArchive(event: event, from: index)
    }
    
    func didSelectEvent(at index: Int) {
        // TODO: Логика обработки выбора события
    }
    
    func addEvent() {
        let addEventVC = AddEventViewController()
        view?.displayAddEventViewController(addEventVC)
    }
    
    // MARK: - Private functions
    private func loadInitialData() {
        // TODO: Здесь должна быть логика загрузки данных
        
        let events = dataManager.loadEvents()
        let archive = dataManager.loadArchive()
        view?.showEvents(events: events)
        view?.showArchiveEvents(events: archive)
    }
}
