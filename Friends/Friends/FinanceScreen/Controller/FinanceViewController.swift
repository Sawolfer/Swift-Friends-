//
//  FinanceViewController.swift
//  Friends
//
//  Created by Савва Пономарев on 26.03.2025.
//

import UIKit
import SnapKit

class FinanceViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        setupNavigationBar()
    }

    override func loadView() {
        self.view = FinanceView()
    }

    // MARK: - Properties

    private var financeView: FinanceView {
        guard let view = view as? FinanceView else {
            assertionFailure("Failed to dequeue FinanceView")
            return FinanceView()
        }
        return view
    }

    // MARK: - Actions

    @objc func onChange() {
        financeView.toogle()
    }

    @objc func onAddNewdebt() {
        let modalViewController = AddExpenseModalViewController()
        let navigationController = UINavigationController(rootViewController: modalViewController)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.prefersGrabberVisible = true
        present(navigationController, animated: true)
    }

    // MARK: - Setup Methods

    private func addTargets() {
        financeView.segmentController.addTarget(self, action: #selector(onChange), for: .valueChanged)
        financeView.addDebtButton.addTarget(self, action: #selector(onAddNewdebt), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Деньги"
    }
}
