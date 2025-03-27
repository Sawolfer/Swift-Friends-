//
//  FinanceViewController.swift
//  Friends
//
//  Created by Савва Пономарев on 26.03.2025.
//

import Foundation
import UIKit
import SnapKit



class FinanceViewController: UIViewController {

    private let segmentController = UISegmentedControl(items: ["Долги", "Бюджеты"])

    let debtTableView = DebtsView()
    let budgetTableView = BudgetsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentController.selectedSegmentIndex = 0
        segmentController.addTarget(self, action: #selector(onChange), for: .valueChanged)

        view.addSubview(segmentController)

        segmentController.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(36)
        }

        setupNavigationBar()
        setupView()
    }

    private func setupView() {
        view.addSubview(debtTableView)
        view.addSubview(budgetTableView)

        debtTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentController.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        budgetTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentController.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        debtTableView.isHidden = false
        budgetTableView.isHidden = true
    }

    private func toogle (){
        debtTableView.isHidden.toggle()
        budgetTableView.isHidden.toggle()
    }

    @objc func onChange(){
        toogle()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Деньги"
    }
}
