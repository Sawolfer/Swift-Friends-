//
//  ViewController.swift
//  Friends
//
//  Created by Алексей on 25.03.2025.
//

import UIKit
import MapKit
import SnapKit

typealias TableCellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

class EventViewController: UIViewController, EventViewProtocol {
    // MARK: - Constants
    private enum Constants {
        static let backgroundLightHex: String = "F5F5F5"
                
        static let tableViewTopOffset: CGFloat = 175
        static let tableOffsetH: CGFloat = 20
        static let heightForRow: CGFloat = 170
        static let heightForRowAnimated: CGFloat = 100
        
        static let parametersOffsetBottom: CGFloat = 10
        static let parametersOffsetLeft: CGFloat = 20
        
        static let navigationBarHeight: CGFloat = 120
        
        static let usingSpringWithDampingValue: CGFloat = 0.55
        static let initialSpringVelocityValue: CGFloat = 0.35
        static let cellsAnimationDuration: CGFloat = 0.85
        static let delayFactor: CGFloat = 0.05
        
        static let tableAnimateOffsetMultiplier: CGFloat = 2
        
        static let segmentedOffset: CGFloat = 20
        
        static let goingStatusImage: UIImage? = UIImage(systemName: "checkmark.circle.fill")
        static let declinedStatusImage: UIImage? = UIImage(systemName: "x.circle.fill")
    }
    
    // MARK: - Properties
    var presenter: EventPresenterProtocol?
    let eventsTable: UITableView = UITableView()
    private var eventsTableLeadingConstraint: Constraint?
    private var eventsTableTrailingConstraint: Constraint?
    let archiveTable: UITableView = UITableView()
    let segmented: SegmentedControlView = SegmentedControlView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewLoaded()
    }
    
    // MARK: - Functions
    func showEvents(events: [EventModel]) {
        eventsTable.reloadData()
    }
    
    func showArchiveEvents(events: [EventModel]) {
        archiveTable.reloadData()
    }
    
    func updateEvent(at index: Int, event: EventModel) {
        eventsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func moveEventToArchive(event: EventModel, from index: Int) {
        eventsTable.performBatchUpdates({
            eventsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }, completion: { _ in
            self.archiveTable.insertRows(at: [IndexPath(
                row: self.archiveTable.numberOfRows(inSection: 0), section: 0
            )], with: .right)
        })
    }
    
    func moveEventFromArchive(event: EventModel, from index: Int) {
        archiveTable.performBatchUpdates({
            archiveTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }, completion: { _ in
            self.eventsTable.insertRows(at: [IndexPath(
                row: self.eventsTable.numberOfRows(inSection: 0), section: 0
            )], with: .right)
        })
    }
    
    // MARK: - Private functions
    private func configureUI() {
        view.backgroundColor = UIColor.background
        configureEvents()
        configureSegmented()
        configureArchive()
    }
    
    private func configureEvents() {
        eventsTable.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        eventsTable.backgroundColor = .clear
        eventsTable.separatorStyle = .none
        eventsTable.allowsSelection = true
        eventsTable.showsVerticalScrollIndicator = false
        
        view.addSubview(eventsTable)
        
        eventsTable.snp.makeConstraints { make in
                self.eventsTableLeadingConstraint = make.leading.equalToSuperview()
                    .inset(Constants.tableOffsetH).constraint
                self.eventsTableTrailingConstraint = make.trailing.equalToSuperview()
                    .inset(Constants.tableOffsetH).constraint
                make.top.equalToSuperview().offset(Constants.tableViewTopOffset)
                make.bottom.equalToSuperview()
            }
    }
    
    private func moveUpBounceAnimation(rowHeight: CGFloat,
                                       duration: TimeInterval, delayFactor: Double) -> TableCellAnimation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: .zero, y: rowHeight)
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: Constants.usingSpringWithDampingValue,
                initialSpringVelocity: Constants.initialSpringVelocityValue,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: .zero, y: .zero)
                }
            )
        }
    }
    
    private func configureArchive() {
        archiveTable.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        archiveTable.delegate = self
        archiveTable.dataSource = self
        
        archiveTable.backgroundColor = .clear
        archiveTable.separatorStyle = .none
        archiveTable.allowsSelection = true
        archiveTable.showsVerticalScrollIndicator = false
        
        view.addSubview(archiveTable)
        
        archiveTable.snp.makeConstraints { make in
            make.leading
                .equalTo(eventsTable.snp.trailing)
                .offset(Constants.tableAnimateOffsetMultiplier * Constants.tableOffsetH)

            make.width.equalTo(segmented.snp.width)
            make.bottom.equalTo(view)
            make.top.equalTo(view).offset(Constants.tableViewTopOffset)
        }
    }
    
    private func configureSegmented() {
        view.addSubview(segmented)
        segmented.snp.makeConstraints { make in
            make.bottom.equalTo(eventsTable.snp.top).offset(-Constants.segmentedOffset)
            make.leading.trailing.equalTo(view).inset(Constants.segmentedOffset)
        }

        segmented.segmentChanged = { [weak self] selectedIndex in
            self?.presenter?.didSelectSegment(at: selectedIndex)
            self?.moveTables(to: selectedIndex)
        }
    }
    
    private func moveTables(to selectedIndex: Int) {
        let leftOffset = selectedIndex == 0 ? Constants.tableOffsetH : -view.frame.width - Constants.tableOffsetH
        let rightOffset = selectedIndex == 0 ? -Constants.tableOffsetH : -view.frame.width - Constants.tableOffsetH
            
        eventsTableLeadingConstraint?.update(offset: leftOffset)
        eventsTableTrailingConstraint?.update(offset: rightOffset)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func triggerSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
        
}

// MARK: - UITableViewDelegate
extension EventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        triggerSelectionFeedback()
        presenter?.didSelectEvent(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = moveUpBounceAnimation(
            rowHeight: Constants.heightForRowAnimated,
            duration: Constants.cellsAnimationDuration,
            delayFactor: Constants.delayFactor
        )
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, for: tableView)
    }
}

// MARK: - UITableViewDataSource
extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case eventsTable:
            return presenter?.numberOfEvents() ?? .zero
        case archiveTable:
            return presenter?.numberOfArchived() ?? .zero
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: indexPath)
            
        guard let eventCell = cell as? EventCell else { return cell }
        switch tableView {
        case eventsTable:
            presenter?.configureEvent(cell: eventCell, at: indexPath.row)
            return eventCell
        case archiveTable:
            presenter?.configureArchived(cell: eventCell, at: indexPath.row)
            return eventCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch tableView {
        case eventsTable:
            let declineAction = UIContextualAction(
                style: .destructive, title: nil
            ) { [weak self] _, _, completionHandler in
                self?.presenter?.didDeclineEvent(at: indexPath.row)
                completionHandler(true)
            }
            
            let acceptAction = UIContextualAction(
                style: .normal, title: nil
            ) { [weak self] _, _, completionHandler in
                self?.presenter?.didAcceptEvent(at: indexPath.row)
                completionHandler(true)
            }
            
            declineAction.backgroundColor = view.backgroundColor
            acceptAction.backgroundColor = view.backgroundColor
            declineAction.image = UIImage(named: "decline")
            acceptAction.image = UIImage(named: "accept")

            return UISwipeActionsConfiguration(actions: [declineAction, acceptAction])
            
        case archiveTable:
            let acceptAction = UIContextualAction(
                style: .destructive, title: nil
            ) { [weak self] _, _, completionHandler in
                self?.presenter?.didRestoreEventFromArchive(at: indexPath.row)
                completionHandler(true)
            }
            
            acceptAction.backgroundColor = view.backgroundColor
            acceptAction.image = UIImage(named: "accept")
            
            return UISwipeActionsConfiguration(actions: [acceptAction])
            
        default:
            return nil
        }
    }
}
