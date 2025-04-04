//
//  PersonCell.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit
import SnapKit

class PersonCell: UITableViewCell {

    // MARK: - Properties

    static let personCellIdentifier = "PersonCell"
    private var isEditable: Bool = false
    private var person: Person?

    weak var delegate: NewExpenseModalViewControllerDelegate?

    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()

    private(set) lazy var debtTextFieldView: UITextField = {
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

    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(borderView)
        stackView.addArrangedSubview(personImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(debtTextFieldView)

        debtTextFieldView.delegate = self

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        borderView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(1)
        }

        setupTextField()
    }

    func configure(with person: Person, isDebitor: Bool, isEditable: Bool = false, resetTextField: Bool = false) {
        self.person = person
        personImageView.image = person.icon
        nameLabel.text = person.name
        print(person.id, person.name)
        debtTextFieldView.text = resetTextField ? "" : "\(PersonContainer.shared.getDebt(of: person)) ₽"
        debtTextFieldView.placeholder = resetTextField ? "Сумма" : ""
        let color = DebtColor.getColor(isDebitor: isDebitor)
        debtTextFieldView.textColor = color
        self.isEditable = isEditable
    }

    private func setupTextField() {
        let editingAction = UIAction { [weak self] _ in
            self?.handleDebtTextChange()
        }
        debtTextFieldView.addAction(editingAction, for: .editingChanged)
    }

    private func handleDebtTextChange() {
        guard let person = person else { return }

        let debtText = debtTextFieldView.text?
            .replacingOccurrences(of: "₽", with: "")
            .trimmingCharacters(in: .whitespaces) ?? "0"

        delegate?.updateSelectedPersonDebt(
            personId: person.id,
            debt: Double(debtText) ?? 0
        )
    }
}

// MARK: - Extensions

extension PersonCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditable
    }
}
