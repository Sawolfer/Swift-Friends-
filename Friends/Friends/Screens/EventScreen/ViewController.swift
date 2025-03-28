//
//  ViewController.swift
//  Friends
//
//  Created by тимур on 25.03.2025.
//

import UIKit
import MapKit
import SnapKit

typealias TableCellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

class ViewController: UIViewController {
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
    let eventsTable: UITableView = UITableView()
    private var eventsTableLeadingConstraint: NSLayoutConstraint?
    private var eventsTableTrailingConstraint: NSLayoutConstraint?
    let archiveTable: UITableView = UITableView()
    var events: [EventModel] = [
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
        EventModel(),
        EventModel(),
        EventModel()
    ]
    var archive: [EventModel] = []
    let segmented: SegmentedControlView = SegmentedControlView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        
        eventsTable.translatesAutoresizingMaskIntoConstraints = false
        
        eventsTableLeadingConstraint = eventsTable
            .leadingAnchor
            .constraint(equalTo: view.leadingAnchor,
                        constant: Constants.tableOffsetH)

        eventsTableLeadingConstraint?.isActive = true
        
        eventsTableTrailingConstraint = eventsTable
            .trailingAnchor
            .constraint(equalTo: view.trailingAnchor,
                        constant: Constants.tableOffsetH)
        eventsTableTrailingConstraint?.isActive = true
        
        eventsTable.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.tableOffsetH)
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
            self?.moveTables(to: selectedIndex)
        }
    }
    
    private func moveTables(to selectedIndex: Int) {
        let leftOffset = selectedIndex == 0 ? Constants.tableOffsetH : -view.frame.width - Constants.tableOffsetH
        let rightOffset = selectedIndex == 0 ? Constants.tableOffsetH : -view.frame.width - Constants.tableOffsetH
        
        eventsTableLeadingConstraint?.constant = leftOffset
        eventsTableTrailingConstraint?.constant = rightOffset

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
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        triggerSelectionFeedback()
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
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case eventsTable:
            return events.count
        case archiveTable:
            return archive.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: indexPath)
            
        guard let eventCell = cell as? EventCell else { return cell }
        switch tableView {
        case eventsTable:
            eventCell.configure(with: events[indexPath.row])
                
            return eventCell
        case archiveTable:
            eventCell.configure(with: archive[indexPath.row])
                
            return eventCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch tableView {
        case eventsTable:
            let declineAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
                let declinedEvent = self.events[indexPath.row]
                declinedEvent.goingStatus = GoingStatus.declined
                self.events.remove(at: indexPath.row)
                self.eventsTable.deleteRows(at: [indexPath], with: .automatic)
                self.archive.append(declinedEvent)
                self.archiveTable.reloadData()
                completionHandler(true)
            }
            
            // TODO: Location span is changing after first accept interaction. That is bad
            let acceptAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
                self.events[indexPath.row].goingStatus = GoingStatus.going
                self.eventsTable.reloadRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            
            // Создание кастомных вьюшек
            declineAction.backgroundColor = view.backgroundColor
            acceptAction.backgroundColor = view.backgroundColor

            declineAction.image = UIImage(named: "decline")
            acceptAction.image = UIImage(named: "accept")

            return UISwipeActionsConfiguration(actions: [declineAction, acceptAction])
        case archiveTable:
            
            let acceptAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
                let acceptedEvent = self.archive[indexPath.row]
                acceptedEvent.goingStatus = GoingStatus.going
                self.archive.remove(at: indexPath.row)
                self.archiveTable.deleteRows(at: [indexPath], with: .automatic)
                self.events.append(acceptedEvent)
                self.eventsTable.reloadData()
                completionHandler(true)
            }
            
            // Создание кастомных вьюшек
            acceptAction.backgroundColor = view.backgroundColor

            acceptAction.image = UIImage(named: "accept")
            
            return UISwipeActionsConfiguration(actions: [acceptAction])
        default:
            return nil
        }
        
    }
}
