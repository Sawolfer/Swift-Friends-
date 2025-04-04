//
//  TableViewAnimator.swift
//  Friends
//
//  Created by Алексей on 26.03.2025.
//

import Foundation
import UIKit

final class TableViewAnimator {
    // MARK: - Properties

    private let animation: TableCellAnimation

    // MARK: - Initialization

    init(animation: @escaping TableCellAnimation) {
        self.animation = animation
    }

    // MARK: - Public functions

    func animate(cell: UITableViewCell, at indexPath: IndexPath, for tableView: UITableView) {
        animation(cell, indexPath, tableView)
    }
}
