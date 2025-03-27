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

    private var persons = [
        Person (name: "Kolya", debt: 1000),
        Person(name: "Alyona", debt: 10)
    ]

    private lazy var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupNavigationBar()
    }

    private func configure() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.personCellIdentifier)

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Деньги"

    }
}

extension FinanceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected: \(persons[indexPath.row].name)")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.personCellIdentifier, for: indexPath)

        guard let personCell = cell as? PersonCell else { return UITableViewCell() }
        let person = persons[indexPath.row]
        personCell.configure(with: person)

        return personCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
