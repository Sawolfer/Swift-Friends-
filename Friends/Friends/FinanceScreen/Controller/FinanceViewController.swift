//
//  FinanceViewController.swift
//  Friends
//
//  Created by Савва Пономарев on 26.03.2025.
//

import UIKit
import SnapKit

class FinanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        addTargets()
        setupNavigationBar()
    }

    @objc func onChange(){
        financeView.toogle()
    }

    private var financeView: FinanceView {
        guard let view = view as? FinanceView else {
            fatalError()
        }
        return view
    }

    override func loadView() {
        self.view = FinanceView()
    }

    private func addTargets(){
        financeView.segmentController.addTarget(self, action: #selector(onChange), for: .valueChanged)
        financeView.addDebtButton.addTarget(self, action: #selector(onAddNewdebt), for: .touchUpInside)
    }

    @objc func onAddNewdebt(){
        let modalViewController = AddExpenseModalViewController()
        let navigationController = UINavigationController(rootViewController: modalViewController)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.prefersGrabberVisible = true
        present(navigationController, animated: true)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Деньги"
    }
}

