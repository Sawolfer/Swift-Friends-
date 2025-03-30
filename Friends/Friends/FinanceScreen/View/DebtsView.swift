//
//  Debts.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

class DebtsView: UIView {

    private var debts: [Debt] {
        return PersonContainer.shared.getDebts(dest: DebtType.from)
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.personCellIdentifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

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

extension DebtsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.personCellIdentifier, for: indexPath)

        guard let personCell = cell as? PersonCell else { return UITableViewCell() }

        let person = debts[indexPath.row].personFrom
        personCell.configure(with: person, isDebitor: false)

        return personCell
    }
}

extension DebtsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected: \(debts[indexPath.row].personFrom.name)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
