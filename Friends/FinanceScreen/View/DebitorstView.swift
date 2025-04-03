//
//  BudgetViewController.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

class DebitorsView: UIView {

    private var debitors: [Debt] {
        return PersonContainer.shared.getDebts(dest: DebtType.to)
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.personCellIdentifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DebitorsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debitors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.personCellIdentifier, for: indexPath)

        guard let personCell = cell as? PersonCell else { return UITableViewCell() }

        let person = debitors[indexPath.row].personTo
        personCell.configure(with: person, isDebitor: true)

        return personCell
    }
}

extension DebitorsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(debitors[indexPath.row].personTo.name)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        TODO: вынести в константу
        return 80
    }
}
