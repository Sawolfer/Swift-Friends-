//
//  PersonCell.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit
import SnapKit

class PersonCell: UITableViewCell {
    static let personCellIdentifier = "PersonCell"
    private var isEditable: Bool = false
    private var person: Person?

    weak var delegate: AddExpenseModalViewControllerDelegate?

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

    private lazy var debtTextFieldView: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.keyboardType = .numberPad
        textField.textColor = .gray
        textField.borderStyle = .none

        return textField
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
        stackView.addArrangedSubview(debtTextFieldView)

        debtTextFieldView.delegate = self

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with person: Person, isDebitor: Bool, isEditable: Bool = false, resetTextField: Bool = false) {
        self.person = person
        iconImageView.image = person.icon
        nameLabel.text = person.name
        print(person.id, person.name)
        debtTextFieldView.text = resetTextField ? "" : "\(PersonContainer.shared.getDebt(of: person)) ₽"
        debtTextFieldView.placeholder = resetTextField ? "Сумма" : ""
        let color = Color.getColor(isDebitor: isDebitor)
        debtTextFieldView.textColor = color
        self.isEditable = isEditable
    }
}

extension PersonCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditable
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let person = person else { return }
        
//        PersonContainer.shared.editDebt(Double(textField.text?.split(separator: " ")[0] ?? "") ?? 0, dest: .to ,person: person)
        delegate?.updateSelectedPersonDebt(person: person)
    }
}
