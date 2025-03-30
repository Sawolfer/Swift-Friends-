//
//  FinanceView.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit
import SnapKit

class FinanceView: UIView {

    private(set) lazy var segmentController = UISegmentedControl(items: ["Долги", "Должники"])
    private lazy var overallDebt: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        switch segmentController.selectedSegmentIndex {
            case 0:
                label.text = PersonContainer.shared.getDebtsSum(dest: .from).description
                label.textColor = .red
            case 1:
                label.text = PersonContainer.shared.getDebtsSum(dest: .to).description
                label.textColor = .green
            default:
                label.text = "0"
                label.textColor = .gray

        }
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private(set) lazy var addDebtButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить долг", for: .normal)
        return button
    }()

    let debtTableView = DebtsView()
    let budgetTableView = DebitorsView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(segmentController)
        segmentController.selectedSegmentIndex = 0

        addSubview(overallDebt)
        addSubview(addDebtButton)
        addSubview(debtTableView)
        addSubview(budgetTableView)

        debtTableView.isHidden = false
        budgetTableView.isHidden = true
    }

    func toogle() {
        debtTableView.isHidden.toggle()
        budgetTableView.isHidden.toggle()
        updateOverallDebt()
    }

    private func updateOverallDebt() {
        switch segmentController.selectedSegmentIndex {
        case 0:
            overallDebt.text = PersonContainer.shared.getDebtsSum(dest: .from).description
            overallDebt.textColor = .red
        case 1:
            overallDebt.text = PersonContainer.shared.getDebtsSum(dest: .to).description
            overallDebt.textColor = .green
        default:
            overallDebt.text = "0"
            overallDebt.textColor = .gray
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        segmentController.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(36)
        }

        overallDebt.snp.makeConstraints { make in
            make.top.equalTo(segmentController.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }

        addDebtButton.snp.makeConstraints { make in
            make.top.equalTo(segmentController.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        debtTableView.snp.makeConstraints { make in
            make.top.equalTo(addDebtButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }

        budgetTableView.snp.makeConstraints { make in
            make.top.equalTo(addDebtButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }

    }

}


