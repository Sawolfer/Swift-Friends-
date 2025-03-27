//
//  PersonCell.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit
import SnapKit


struct Person {
    var icon: UIImage {
        return UIImage(named: "custom") ?? UIImage(systemName: "person.circle")!
    }
    var name: String
    var debt: Double
}

class PersonCell: UITableViewCell {
    static let personCellIdentifier = "PersonCell"

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()

    private lazy var debtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(debtLabel)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with person: Person) {
        iconImageView.image = person.icon
        nameLabel.text = person.name
        debtLabel.text = "\(person.debt) р"
    }
}
